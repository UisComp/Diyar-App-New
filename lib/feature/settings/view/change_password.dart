import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late SettingsController settingsController;
  @override
  void initState() {
    super.initState();
    settingsController = SettingsController.get(context);
  }

  @override
  void dispose() {
    super.dispose();
    settingsController.currentPassword.dispose();
    settingsController.newPassword.dispose();
    settingsController.newPasswordConfirmation.dispose();
    settingsController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.change_password.tr()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocConsumer<SettingsController, SettingsState>(
                listener: (context, settingsState) {
                  if (settingsState is ChangePasswordSuccessfullyState) {
                    AppFunctions.successMessage(
                      context,
                      message:
                          settingsController
                              .changePasswordResponseModel
                              .message ??
                          LocaleKeys.change_password_successfully.tr(),
                    );
                    context.pop();
                  }
                  if (settingsState is ChangePasswordFailureState) {
                    AppFunctions.errorMessage(
                      context,
                      message:
                          settingsController
                              .changePasswordResponseModel
                              .message ??
                          LocaleKeys.change_password_failed.tr(),
                    );
                  }
                },
                builder: (context, settingsState) {
                  return Column(
                    children: [
                      21.ph,
                      CustomTextFormField(
                        controller: settingsController.currentPassword,
                        hintText: LocaleKeys.current_password.tr(),
                      ),
                      24.ph,
                      CustomTextFormField(
                        controller: settingsController.newPassword,
                        hintText: LocaleKeys.new_password.tr(),
                      ),
                      24.ph,
                      CustomTextFormField(
                        controller: settingsController.newPasswordConfirmation,
                        hintText: LocaleKeys.confirm_new_password.tr(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          CustomButton(
            buttonColor: AppColors.primaryColor,
            buttonText: LocaleKeys.update_password.tr(),
            onPressed: () async {
              await settingsController.changePassword();
            },
          ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
        ],
      ),
    );
  }
}
