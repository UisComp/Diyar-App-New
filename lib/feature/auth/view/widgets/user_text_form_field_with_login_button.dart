import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
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
  @override
  void initState() {
    super.initState();
    AuthController.get(context).initController();
  }

  void toggleVisibilityPassword() {
    setState(() {
      isObscurePassword = !isObscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.get(context);
    return BlocConsumer<AuthController, AuthState>(
      listener: (context, authState) {},
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
              controller: authController.emailControllerForLogin,
              hintText: LocaleKeys.email.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            14.ph,
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
              controller: authController.passwordControllerForLogin,
              hintText: LocaleKeys.password.tr(),
              suffixIcon: IconButton(
                onPressed: toggleVisibilityPassword,
                icon: Icon(
                  isObscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
              ),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context.push(RoutesName.forgetPasswordScreen);
                },
                child: AppText(
                  textAlign: TextAlign.start,
                  LocaleKeys.forget_password.tr(),
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    fontSize: 13.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 16.sp),
            8.ph,
            CustomButton(
              buttonHeight: 52.h,
              buttonText: LocaleKeys.login.tr(),
              isLoading: isLoading,
              onPressed: () async {
                if (!isLoading && widget.formKey.currentState!.validate()) {
                  await authController.login();
                }
              },
              buttonColor: AppColors.primaryColor,
            ).paddingSymmetric(horizontal: 16.sp),
          ],
        );
      },
    );
  }
}
