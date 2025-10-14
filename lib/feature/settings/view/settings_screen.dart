import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_title.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsController settingsController;
  @override
  void initState() {
    super.initState();
    settingsController = SettingsController.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageController, LanguageState>(
      builder: (context, state) {
        return BlocConsumer<SettingsController, SettingsState>(
          listener: (context, settingsState) {
            if (settingsState is DeleteAccountSuccessfullyState) {
              AppFunctions.successMessage(
                context,
                message:
                    settingsController.deleteAccountResponseModel.message ??
                    LocaleKeys.delete_account_success.tr(),
              );
              context.pop();
              context.go(RoutesName.onBoarding);
            }
            if (settingsState is DeleteAccountFailureState) {
              AppFunctions.errorMessage(
                context,
                message:
                    settingsController.deleteAccountResponseModel.message ??
                    LocaleKeys.delete_account_failure.tr(),
              );
            }
          },
          builder: (context, settingsState) {
            return Scaffold(
              appBar: CustomAppBar(
                titleAppBar: LocaleKeys.settings.tr(),
                showIconNotification: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTitle(title: LocaleKeys.account.tr()),
                    12.ph,
                    CustomContainerInformation(
                      onTap: () {
                        context.push(RoutesName.personalInformation);
                      },
                      titleContainer: LocaleKeys.personal_information.tr(),
                      descriptionContainer: LocaleKeys.desc_personal_information
                          .tr(),
                      svgIcon: Assets.images.svg.person,
                    ),
                    24.ph,
                    CustomContainerInformation(
                      onTap: () async {
                        await showDeleteAccountDialog(
                          isLoading: settingsState is DeleteAccountLoadingState,
                          context,
                          onDelete: () async {
                            await SettingsController.get(
                              context,
                            ).deleteAccount();
                          },
                        );
                      },
                      titleContainer: LocaleKeys.delete_account.tr(),
                      descriptionContainer: LocaleKeys.erase_all_data.tr(),
                      svgIcon: Assets.images.svg.deleteUser,
                    ),
                    24.ph,
                    CustomContainerInformation(
                      onTap: () {
                        context.push(RoutesName.changePasswordScreen);
                      },
                      titleContainer: LocaleKeys.change_password.tr(),
                      descriptionContainer: LocaleKeys.desc_change_password
                          .tr(),
                      svgIcon: Assets.images.svg.lock,
                    ),
                    24.ph,
                    CustomContainerInformation(
                      onTap: () {
                        context.push(RoutesName.bioMetricScreen);
                      },
                      titleContainer: LocaleKeys.biometric_feature.tr(),
                      descriptionContainer: LocaleKeys.biometric.tr(),
                      svgIcon: Assets.images.svg.biometric,
                    ),
                    32.ph,
                    CustomTitle(title: LocaleKeys.preferences.tr()),
                    24.ph,
                    CustomContainerInformation(
                      onTap: () {
                        context.push(RoutesName.appPreferencesScreen);
                      },
                      titleContainer: LocaleKeys.app_preferences.tr(),
                      descriptionContainer: LocaleKeys.desc_app_preferences
                          .tr(),
                      svgIcon: Assets.images.svg.settings,
                    ),
                    24.ph,
                    CustomContainerInformation(
                      onTap: () {
                        context.push(RoutesName.privacyPolicy);
                      },
                      titleContainer: LocaleKeys.privacy_settings.tr(),
                      descriptionContainer: LocaleKeys.desc_privacy_settings
                          .tr(),
                      svgIcon: Assets.images.svg.privacy,
                    ),
                    32.ph,
                    CustomTitle(title: LocaleKeys.contact_us.tr()),
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
          },
        );
      },
    );
  }
}
