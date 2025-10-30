import 'dart:async';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/emergency/view/widgets/custom_emergency_number_button.dart';
import 'package:diyar_app/feature/emergency/view/widgets/description_under_button.dart';
import 'package:diyar_app/feature/emergency/view/widgets/description_under_button_after_make_call.dart';
import 'package:diyar_app/feature/emergency/view/widgets/emergency_number_text.dart';
import 'package:diyar_app/feature/emergency/view/widgets/inner_contianer.dart';
import 'package:diyar_app/feature/emergency/view/widgets/outer_container.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
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
  late SettingsController settingsController;
  bool alreadyTriggered = false;

  @override
  void initState() {
    super.initState();
    settingsController = SettingsController.get(context);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  void startHoldTimer() {
    alreadyTriggered = false;
    _holdProgress = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _holdProgress += 0.05 / activationDuration;

        if (_holdProgress >= 1.0 && !alreadyTriggered) {
          _timer?.cancel();
          alreadyTriggered = true;
          _triggerEmergency();
        }
      });
    });
  }

  void cancelHoldTimer() {
    _timer?.cancel();
    if (!alreadyTriggered) {
      setState(() => _holdProgress = 0.0);
    }
  }

  void _triggerEmergency() async {
    final emergencyNumber =
        settingsController.configResponseModel.data?.emergencyNumber ?? '';
    final Uri callUri = Uri(scheme: 'tel', path: emergencyNumber);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        AppFunctions.errorMessage(
          context,
          message: 'Could not launch $emergencyNumber',
        );
      }
    } catch (e) {
      AppFunctions.errorMessage(
        context,
        message: 'Could not launch $emergencyNumber',
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
bool get isDark => Theme.of(context).brightness == Brightness.dark;

Color get backgroundColor =>
    isDark ? AppColors.darkBackground : AppColors.lightBackground;

Color get textSecondary =>
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

Color get cardColor =>
    isDark ? AppColors.darkCard : AppColors.lightCard;

int get remainingSeconds {
  int sec = activationDuration - (_holdProgress * activationDuration).ceil();
  sec = sec.clamp(0, activationDuration);
  if (_holdProgress == 0.0) sec = activationDuration;
  return sec;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(titleAppBar: LocaleKeys.emergency.tr()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmergencyNumberText(textSecondary: textSecondary),
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
                        const InnerContianer(),
                        OuterContainer(
                          holdProgress: _holdProgress,
                          isDark: isDark,
                        ),
                        CustomEmergencyNumberButton(
                          holdProgress: _holdProgress,
                          remainingSeconds: remainingSeconds,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            40.ph,
            DescriptionUnderButtonAfterMakeCall(holdProgress: _holdProgress, remainingSeconds: remainingSeconds),
            30.ph,
            DescriptionUnderButton(
              cardColor: cardColor,
              activationDuration: activationDuration,
            ),
          ],
        ),
      ),
    );
  }
}



