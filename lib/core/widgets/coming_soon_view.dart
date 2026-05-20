import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ComingSoonView extends StatefulWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    this.featureName,
    this.description,
    this.icon = Icons.construction_rounded,
  });

  final String title;
  final String? featureName;
  final String? description;
  final IconData icon;

  @override
  State<ComingSoonView> createState() => _ComingSoonViewState();
}

class _ComingSoonViewState extends State<ComingSoonView>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(titleAppBar: widget.title),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 220.w,
                height: 220.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 6.28318,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  AppColors.primaryColor.withValues(alpha: 0.0),
                                  AppColors.primaryColor.withValues(alpha: 0.18),
                                  AppColors.accentHoverColor
                                      .withValues(alpha: 0.30),
                                  AppColors.primaryColor.withValues(alpha: 0.18),
                                  AppColors.primaryColor.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 190.w,
                      height: 190.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundColor,
                      ),
                    ),
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 150.w,
                        height: 150.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor.withValues(alpha: 0.18),
                              AppColors.accentHoverColor.withValues(alpha: 0.10),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor
                                  .withValues(alpha: 0.25),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 64.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              32.ph,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppText(
                  LocaleKeys.coming_soon.tr(),
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              20.ph,
              AppText(
                widget.featureName ?? widget.title,
                textAlign: TextAlign.center,
                style: AppStyle.fontSize22Bold(context).copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              12.ph,
              AppText(
                widget.description ??
                    LocaleKeys.feature_under_construction.tr(),
                textAlign: TextAlign.center,
                style: AppStyle.fontSize16Regular(context).copyWith(
                  color: secondaryText,
                  height: 1.5,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RoutesName.homeLayout);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 20.sp,
                    color: AppColors.whiteColor,
                  ),
                  label: AppText(
                    LocaleKeys.back_to_home.tr(),
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
              16.ph,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                    12.pw,
                    Expanded(
                      child: AppText(
                        LocaleKeys.feature_under_construction.tr(),
                        style: AppStyle.fontSize12Regular(context).copyWith(
                          color: secondaryText,
                          height: 1.4,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
