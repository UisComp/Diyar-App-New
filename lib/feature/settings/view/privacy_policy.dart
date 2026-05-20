import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.whiteColor;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark
        ? const Color(0xFF1F242B)
        : AppColors.primaryColor.withValues(alpha: 0.08);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(titleAppBar: LocaleKeys.privacy_settings.tr()),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.12),
                    AppColors.accentHoverColor.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withValues(alpha: 0.18),
                    ),
                    child: Icon(
                      Icons.privacy_tip_rounded,
                      color: AppColors.primaryColor,
                      size: 28.sp,
                    ),
                  ),
                  14.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          LocaleKeys.privacy_policy_title.tr(),
                          style: AppStyle.fontSize18Bold(context).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        4.ph,
                        AppText(
                          LocaleKeys.desc_privacy_settings.tr(),
                          style: AppStyle.fontSize12Regular(context).copyWith(
                            color: secondaryText,
                            height: 1.4,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.ph,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.blackColor.withValues(alpha: 0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: AppText(
                LocaleKeys.privacy_policy.tr(),
                textAlign: TextAlign.start,
                style: AppStyle.fontSize14RegularNewsReader(context).copyWith(
                  color: secondaryText,
                  height: 1.7,
                ),
              ),
            ),
            24.ph,
          ],
        ),
      ),
    );
  }
}
