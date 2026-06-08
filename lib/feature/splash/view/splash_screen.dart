import 'dart:async';

import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Elegant, premium animated splash shown after the native splash. Reveals the
/// L'amer app logo over the brand gradient with a radial glow pulse, then the
/// "Designed by Diyar Co. — in partnership with LAMAR" credit, before handing
/// off to onboarding (guest) or the home layout (signed-in user).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _pulse;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _glowScale;
  late final Animation<double> _creditOpacity;
  late final Animation<double> _creditSlide;

  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _glowOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    );
    _glowScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _creditOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _creditSlide = Tween<double>(begin: 22.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _intro.forward();
    _navTimer = Timer(const Duration(milliseconds: 2900), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    final loggedIn = userModel?.data?.accessToken != null;
    context.go(loggedIn ? RoutesName.homeLayout : RoutesName.onBoarding);
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.brandHeaderGradient,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Spacer(flex: 3),
                _logo(),
                const Spacer(flex: 2),
                _credit(context),
                28.ph,
                _progressBar(),
                48.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_intro, _pulse]),
      builder: (context, _) {
        final pulse = 1.0 + (_pulse.value * 0.06);
        return SizedBox(
          height: 280.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: _glowOpacity.value * 0.9,
                child: Transform.scale(
                  scale: _glowScale.value * pulse,
                  child: Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.logoGlowGradient,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: _logoOpacity.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Assets.images.appLogo.image(
                      height: 150.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _credit(BuildContext context) {
    return AnimatedBuilder(
      animation: _intro,
      builder: (context, child) {
        return Opacity(
          opacity: _creditOpacity.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _creditSlide.value),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                LocaleKeys.designed_by.tr(),
                style: TextStyle(
                  color: AppColors.white70Color,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              6.pw,
              AppText(
                LocaleKeys.diyar_co.tr(),
                style: TextStyle(
                  color: AppColors.diyarColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          10.ph,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.accentHoverColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  LocaleKeys.in_partnership_with.tr(),
                  style: TextStyle(
                    color: AppColors.white70Color,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                6.pw,
                AppText(
                  LocaleKeys.lamar.tr(),
                  style: TextStyle(
                    color: AppColors.accentHoverColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return AnimatedBuilder(
      animation: _intro,
      builder: (context, _) {
        return Container(
          width: 140.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4.r),
          ),
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: _intro.value.clamp(0.06, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
