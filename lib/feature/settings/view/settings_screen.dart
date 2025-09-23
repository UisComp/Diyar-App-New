import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_title.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.settings.tr(),
        showIconNotification: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.ph,
            CustomTitle(title: LocaleKeys.account.tr()),
            12.ph,
            CustomContainerInformation(
              onTap: () {
                context.push(RoutesName.personalInformation);
              },
              titleContainer: LocaleKeys.personal_information.tr(),
              descriptionContainer: LocaleKeys.desc_personal_information.tr(),
              svgIcon: Assets.images.svg.person,
            ),
            24.ph,
            CustomContainerInformation(
              onTap: () {
                context.push(RoutesName.changePasswordScreen);
              },
              titleContainer: LocaleKeys.change_password.tr(),
              descriptionContainer: LocaleKeys.desc_change_password.tr(),
              svgIcon: Assets.images.svg.lock,
            ),
            32.ph,
            CustomTitle(title: LocaleKeys.preferences.tr()),
            24.ph,
            CustomContainerInformation(
              onTap: () {
                context.push(RoutesName.appPreferencesScreen);
              },
              titleContainer: LocaleKeys.app_preferences.tr(),
              descriptionContainer: LocaleKeys.desc_app_preferences.tr(),
              svgIcon: Assets.images.svg.settings,
            ),
            24.ph,
            CustomContainerInformation(
              onTap: () {
                context.push(RoutesName.privacyPolicy);
              },
              titleContainer: LocaleKeys.privacy_settings.tr(),
              descriptionContainer: LocaleKeys.desc_privacy_settings.tr(),
              svgIcon: Assets.images.svg.privacy,
            ),
            32.ph,
            CustomTitle(title: LocaleKeys.contact_us.tr()),
            24.ph,
            CustomContainerInformation(
              onTap: () {
                // context.push(RoutesName.helpSupportScreen);
              },
              titleContainer: LocaleKeys.help_support.tr(),
              descriptionContainer: LocaleKeys.desc_help_support.tr(),
              svgIcon: Assets.images.svg.help,
            ),
            24.ph,
            CustomContainerInformation(
              onTap: () {
                context.push(RoutesName.contactUsScreen);
              },
              titleContainer: LocaleKeys.contact_us.tr(),
              descriptionContainer: LocaleKeys.desc_contact_us.tr(),
              svgIcon: Assets.images.svg.contactUs,
            ),
          ],
        ),
      ),
    );
  }
}
