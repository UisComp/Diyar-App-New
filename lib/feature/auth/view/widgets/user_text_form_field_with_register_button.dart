import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_phone_field.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserTextFormFieldForRegister extends StatefulWidget {
  const UserTextFormFieldForRegister({super.key});

  @override
  State<UserTextFormFieldForRegister> createState() =>
      _UserTextFormFieldForRegisterState();
}

class _UserTextFormFieldForRegisterState
    extends State<UserTextFormFieldForRegister> {
  bool isObscurePassword = true;
  bool isObscurePasswordForConformation = true;
  late AuthController authController;
  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
  }

  void toggleVisibilityPassword() {
    setState(() {
      isObscurePassword = !isObscurePassword;
    });
  }

  void toggleVisibilityPasswordForConfirmation() {
    setState(() {
      isObscurePasswordForConformation = !isObscurePasswordForConformation;
    });
  }

  @override
  void dispose() {
    super.dispose();
    authController.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthController, AuthState>(
      listener: (context, authState) {
        if (authState is RegisterSuccessState) {
          AppFunctions.successMessage(
            context,
            message: LocaleKeys.account_created_successfully.tr(),
          );
          context.go(RoutesName.login);
        }
        if (authState is RegisterFailureState) {
          AppFunctions.errorMessage(
            description: "${authController.registerResponseModel.message}",
            context,
            message: LocaleKeys.account_created_failed.tr(),
          );
        }
      },
      builder: (context, authState) {
        return Column(
          children: [
            CustomTextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (name) {
                if (name!.isEmpty) {
                  return LocaleKeys.please_enter_valid_name.tr();
                }
                return null;
              },
              contentPadding: EdgeInsets.all(20.sp),
              controller: authController.nameController,
              labelText: LocaleKeys.name.tr(),
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.person, color: AppColors.blackColor),
            ),
            24.ph,
            CustomTextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => ValidatorHelper.validateEmail(
                email,
                emptyMessage: LocaleKeys.please_enter_your_email.tr(),
                invalidMessage: LocaleKeys.please_enter_a_valid_email.tr(),
              ),
              contentPadding: EdgeInsets.all(20.sp),
              controller: authController.emailControllerForRegister,
              labelText: LocaleKeys.email.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.blackColor,
              ),
            ),
            24.ph,
            CustomTextFormField(
              obscureText: isObscurePassword,
              keyboardType: TextInputType.visiblePassword,
              validator: (password) => ValidatorHelper.validatePhoneOrPassword(
                password,
                emptyMessage: LocaleKeys.please_enter_your_password.tr(),
                spaceMessage: LocaleKeys.please_enter_valid_password.tr(),
                minLength: 8,
                minLengthMessage: LocaleKeys
                    .password_must_be_at_least_8_characters
                    .tr(),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              contentPadding: EdgeInsets.all(20.sp),
              controller: authController.passwordControllerForRegister,
              labelText: LocaleKeys.password.tr(),
              suffixIcon: IconButton(
                onPressed: toggleVisibilityPassword,
                icon: Icon(
                  isObscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              prefixIcon: Icon(Icons.lock, color: AppColors.blackColor),
            ),
            24.ph,
            CustomTextFormField(
              obscureText: isObscurePasswordForConformation,
              keyboardType: TextInputType.visiblePassword,
              validator: (confirmPassword) =>
                  ValidatorHelper.validatePasswordConfirmation(
                    confirmPassword,
                    originalPassword:
                        authController.passwordControllerForRegister.text,
                    emptyMessage: LocaleKeys.please_enter_your_password.tr(),
                    notMatchMessage: LocaleKeys.passwords_do_not_match.tr(),
                  ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              contentPadding: EdgeInsets.all(20.sp),
              controller:
                  authController.passwordConfirmationControllerForRegister,
              labelText: LocaleKeys.password_confirmation.tr(),
              suffixIcon: IconButton(
                onPressed: toggleVisibilityPasswordForConfirmation,
                icon: Icon(
                  isObscurePasswordForConformation
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              prefixIcon: Icon(Icons.lock, color: AppColors.blackColor),
            ),
            24.ph,
            CustomPhoneField(
              controller: authController.phoneController,
              hintText: LocaleKeys.phone_number_in_your_contract.tr(),
            ),
          ],
        );
      },
    );
  }
}
