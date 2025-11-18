import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_app_pref_text.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_langauge.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_switch_list_tile.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_theme_app.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:diyar_app/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPreferencesScreen extends StatelessWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageController, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(titleAppBar: LocaleKeys.app_preferences.tr()),
          body: SingleChildScrollView(
            child: BlocConsumer<SettingsController, SettingsState>(
              listener: (context, settingsState) {},
              builder: (context, state) {
                final settingsController = SettingsController.get(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppPrefText(
                      text: LocaleKeys.language.tr(),
                    ).paddingSymmetric(horizontal: 16.w),
                    20.ph,
                    const CustomLangauge(),
                    25.ph,
                    CustomAppPrefText(
                      text: LocaleKeys.theme.tr(),
                    ).paddingSymmetric(horizontal: 16.w),
                    20.ph,
                    const CustomThemeApp(),
                    30.ph,
                    CustomAppPrefText(
                      text: LocaleKeys.notifications.tr(),
                    ).paddingSymmetric(horizontal: 16.w),
                    15.ph,
                    CustomSwitchListTile(
                      // value: settingsController.enableNotification,
                      value: enableNotifications,
                      onChanged: (value) {
                        settingsController.toggleNotification();
                      },
                      title: LocaleKeys.push_notifications.tr(),
                      subtitle: LocaleKeys.desc_push_notifications.tr(),
                    ),
                    CustomSwitchListTile(
                      value: settingsController.emailNotification,
                      onChanged: (value) {
                        settingsController.toggleEmailNotification();
                      },
                      title: LocaleKeys.email_notifications.tr(),
                      subtitle: LocaleKeys.desc_email_notifications.tr(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
