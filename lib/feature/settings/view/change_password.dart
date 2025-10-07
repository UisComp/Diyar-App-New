import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    settingsController = SettingsController.get(context);
  }

  @override
  void dispose() {
    settingsController.currentPassword.dispose();
    settingsController.newPassword.dispose();
    settingsController.newPasswordConfirmation.dispose();
    super.dispose();
  }

  bool isObsecureForCurrentPassword = true;
  bool isObsecureForNewPassword = true;
  bool isObsecureForNewPasswordConfirmation = true;

  void toggleCurrentPassword() {
    setState(() {
      isObsecureForCurrentPassword = !isObsecureForCurrentPassword;
    });
  }

  void toggleNewPassword() {
    setState(() {
      isObsecureForNewPassword = !isObsecureForNewPassword;
    });
  }

  void toggleNewPasswordConfirmation() {
    setState(() {
      isObsecureForNewPasswordConfirmation =
          !isObsecureForNewPasswordConfirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.change_password.tr()),
      body: BlocConsumer<SettingsController, SettingsState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccessfullyState) {
            AppFunctions.successMessage(
              context,
              message:
                  settingsController.changePasswordResponseModel.message ??
                  LocaleKeys.change_password_successfully.tr(),
            );
            context.pop();
          }
          if (state is ChangePasswordFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  settingsController.changePasswordResponseModel.message ??
                  LocaleKeys.change_password_failed.tr(),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.ph,
                        CustomTextFormField(
                          suffixIcon: IconButton(
                            onPressed: toggleCurrentPassword,
                            icon: Icon(
                              isObsecureForCurrentPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: settingsController.currentPassword,
                          hintText: LocaleKeys.current_password.tr(),
                          obscureText: isObsecureForCurrentPassword,
                          validator: (value) =>
                              ValidatorHelper.validatePhoneOrPassword(
                                value,
                                emptyMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                spaceMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                minLength: 8,
                                minLengthMessage: LocaleKeys
                                    .password_must_be_at_least_8_characters
                                    .tr(),
                              ),
                        ),
                        24.ph,
                        CustomTextFormField(
                          suffixIcon: IconButton(
                            onPressed: toggleNewPassword,
                            icon: Icon(
                              isObsecureForNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: settingsController.newPassword,
                          hintText: LocaleKeys.new_password.tr(),
                          obscureText: isObsecureForNewPassword,
                          validator: (value) =>
                              ValidatorHelper.validatePhoneOrPassword(
                                value,
                                emptyMessage: LocaleKeys
                                    .please_enter_valid_password
                                    .tr(),
                                spaceMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                minLength: 8,
                                minLengthMessage: LocaleKeys
                                    .password_must_be_at_least_8_characters
                                    .tr(),
                              ),
                        ),
                        24.ph,
                        CustomTextFormField(
                          suffixIcon: IconButton(
                            onPressed: toggleNewPasswordConfirmation,
                            icon: Icon(
                              isObsecureForNewPasswordConfirmation
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller:
                              settingsController.newPasswordConfirmation,
                          hintText: LocaleKeys.confirm_new_password.tr(),
                          obscureText: isObsecureForNewPasswordConfirmation,
                          validator: (value) =>
                              ValidatorHelper.validatePasswordConfirmation(
                                value,
                                emptyMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                originalPassword:
                                    settingsController.newPassword.text,
                                notMatchMessage: LocaleKeys
                                    .passwords_do_not_match
                                    .tr(),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  isLoading: state is ChangePasswordLoadingState,
                  buttonColor: AppColors.primaryColor,
                  buttonText: LocaleKeys.update_password.tr(),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await settingsController.changePassword();
                    }
                  },
                ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
