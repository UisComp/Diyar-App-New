import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPreferencesScreen extends StatelessWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.app_preferences.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            41.ph,
            CustomAppPrefText(
              text: LocaleKeys.language.tr(),
            ).paddingSymmetric(horizontal: 16.w),
            28.ph,
            Row(
              children: [
                CustomContainerLanguageOrTheme(
                  text: LocaleKeys.english.tr(),
                ).paddingOnly(left: 16.w),
                10.pw,
                CustomContainerLanguageOrTheme(text: LocaleKeys.arabic.tr()),
              ],
            ),
            36.ph,
            CustomAppPrefText(
              text: LocaleKeys.theme.tr(),
            ).paddingSymmetric(horizontal: 16.w),
            28.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomContainerLanguageOrTheme(
                    text: LocaleKeys.light.tr(),
                  ),
                ),
                10.pw,
                Expanded(
                  child: CustomContainerLanguageOrTheme(
                    text: LocaleKeys.dark.tr(),
                  ),
                ),
                10.pw,
                Expanded(
                  child: CustomContainerLanguageOrTheme(
                    text: LocaleKeys.system.tr(),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.w),
            36.ph,
            CustomAppPrefText(
              text: LocaleKeys.notifications.tr(),
            ).paddingSymmetric(horizontal: 16.w),
            20.ph,
            CustomSwitchListTile(
              value: false,
              onChanged: (value) {},
              title: LocaleKeys.push_notifications.tr(),
              subtitle: LocaleKeys.desc_push_notifications.tr(),
            ),
            CustomSwitchListTile(
              value: true,
              onChanged: (value) {},
              title: LocaleKeys.email_notifications.tr(),
              subtitle: LocaleKeys.desc_email_notifications.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
    required this.subtitle,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: AppStyle.fontSize16Regular.copyWith(
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppStyle.fontSize14RegularNewsReader.copyWith(
          color: AppColors.descContainerColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryColor,
      inactiveThumbColor: AppColors.whiteColor,
      activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.3),
      inactiveTrackColor: AppColors.greyColor.withValues(alpha: 0.4),
    );
  }
}

class CustomAppPrefText extends StatelessWidget {
  const CustomAppPrefText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.fontSize22Bold);
  }
}

class CustomContainerLanguageOrTheme extends StatelessWidget {
  const CustomContainerLanguageOrTheme({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          text,
          style: AppStyle.fontSize16Regular.copyWith(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
