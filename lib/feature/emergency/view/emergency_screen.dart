import 'dart:async';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  int activationDuration = 3;
  double _holdProgress = 0.0;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  void startHoldTimer() {
    _holdProgress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _holdProgress += 0.05 / activationDuration;
        if (_holdProgress >= 1.0) {
          _timer?.cancel();
          _triggerEmergency();
        }
      });
    });
  }

  void cancelHoldTimer() {
    _timer?.cancel();
    setState(() => _holdProgress = 0.0);
  }

  void _triggerEmergency() async {
    const emergencyNumber = '911';
    final Uri callUri = Uri(scheme: 'tel', path: emergencyNumber);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        AppFunctions.errorMessage(context,
            message: 'Could not launch $emergencyNumber');
      }
    } catch (e) {
      AppFunctions.errorMessage(context,
          message: 'Could not launch $emergencyNumber');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    int remainingSeconds =
        activationDuration - (_holdProgress * activationDuration).ceil();
    if (_holdProgress == 0.0) remainingSeconds = activationDuration;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.emergency.tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Emergency Call',
              style: TextStyle(
                color: textSecondary,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            50.ph,
            GestureDetector(
              onLongPressStart: (_) => startHoldTimer(),
              onLongPressEnd: (_) => cancelHoldTimer(),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  double scale =
                      1 + (_pulseController.value * 0.1 * (1 - _holdProgress));
                  return Transform.scale(
                    scale: scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.redAccent.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: _holdProgress,
                            strokeWidth: 12,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.redAccent),
                            backgroundColor:
                                isDark ? Colors.white12 : Colors.black12,
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: _holdProgress * 10,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.white, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                "${remainingSeconds}s",
                                style: AppStyle.fontSize22Bold(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            40.ph,
            Text(
              _holdProgress > 0
                  ? "Hold to activate (${remainingSeconds}s)"
                  : "Press & Hold to Start",
              style: AppStyle.fontSize16Regular(context)
            ),
            30.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Hold the red button for ${activationDuration}s to make an immediate emergency call. "
                  "Release before it completes to cancel the call.",
                  style: AppStyle.fontSize16Regular(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
