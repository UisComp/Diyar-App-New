import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserTextFormFieldWithLoginButton extends StatefulWidget {
  const UserTextFormFieldWithLoginButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<UserTextFormFieldWithLoginButton> createState() =>
      _UserTextFormFieldWithLoginButtonState();
}

class _UserTextFormFieldWithLoginButtonState
    extends State<UserTextFormFieldWithLoginButton> {
  bool isObscurePassword = true;
  late AuthController authController;
  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
    authController.initController();
  }

  void toggleVisibilityPassword() {
    setState(() {
      isObscurePassword = !isObscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthController, AuthState>(
      listener: (context, authState) {
        if (authState is LoginSuccessState) {
          AppFunctions.successMessage(
            context,
            message: LocaleKeys.login_successfully.tr(),
          );
          context.go(RoutesName.homeLayout);
        }
        if (authState is LoginFailureState) {
          AppFunctions.errorMessage(
            description: authController.loginResponseModel.message,
            context,
            message: LocaleKeys.login_failed.tr(),
          );
        }
      },
      builder: (context, authState) {
        final isLoading = authState is LoginLoadingState;
        return Column(
          children: [
            CustomTextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => ValidatorHelper.validateEmail(
                email,
                emptyMessage: LocaleKeys.please_enter_your_email.tr(),
                invalidMessage: LocaleKeys.please_enter_a_valid_email.tr(),
              ),
              contentPadding: EdgeInsets.all(20.sp),
              controller: authController.emailControllerForLogin,
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
              controller: authController.passwordControllerForLogin,
              labelText: LocaleKeys.password.tr(),
              suffixIcon: IconButton(
                onPressed: toggleVisibilityPassword,
                icon: Icon(
                  isObscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              prefixIcon: Icon(Icons.lock, color: AppColors.blackColor),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  context.push(RoutesName.forgetPasswordScreen);
                },
                child: Text(
                  textAlign: TextAlign.start,
                  LocaleKeys.forgot_password.tr(),
                  style: AppStyle.fontSize16Regular.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 16.sp),
            CustomButton(
              buttonHeight: 50.h,
              buttonText: LocaleKeys.login.tr(),
              isLoading: isLoading,
              onPressed: () async {
                if (!isLoading && widget.formKey.currentState!.validate()) {
                  await authController.login();
                }
              },
              buttonColor: AppColors.primaryColor,
            ).paddingSymmetric(horizontal: 16.sp),
            // CustomButton(
            //   buttonHeight: 50.h,
            //   buttonText: LocaleKeys.login.tr(),
            //   onPressed: () async {
            //     if (widget.formKey.currentState!.validate()) {
            //       await authController.login();
            //     }
            //   },
            //   buttonColor: AppColors.primaryColor,
            // ).paddingSymmetric(horizontal: 16.sp),
          ],
        );
      },
    );
  }
}
