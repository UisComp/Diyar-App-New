import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late AuthController authController;
  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
  }

  final formKey = GlobalKey<FormState>();
  bool isSecurePassword = true;
  bool isSecurePasswordConfirmation = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.reset_password.tr()),
      body: Form(
        key: formKey,
        child: BlocConsumer<AuthController, AuthState>(
          listener: (context, authState) {
            if (authState is ResetPasswordSuccessState) {
              AppFunctions.successMessage(
                context,
                message: LocaleKeys.change_password_successfully.tr(),
              );
              context.go(RoutesName.login);
            }
            if (authState is ResetPasswordFailureState) {
              AppFunctions.errorMessage(
                context,
                message: LocaleKeys.change_password_failed.tr(),
              );
            }
          },
          builder: (context, authState) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        40.ph,
                        SvgPicture.asset(
                          Assets.images.svg.resetPassword,
                          width: double.infinity,
                          height: 200.h,
                        ),
                        40.ph,
                        CustomTextFormField(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isSecurePassword = !isSecurePassword;
                              });
                            },
                            icon: Icon(
                              isSecurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          obscureText: isSecurePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              ValidatorHelper.validatePhoneOrPassword(
                                password,
                                emptyMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                spaceMessage: LocaleKeys
                                    .please_enter_valid_password
                                    .tr(),
                              ),
                          controller:
                              authController.passwordControllerForResetPassword,
                          hintText: LocaleKeys.new_password.tr(),
                        ),
                        15.ph,
                        CustomTextFormField(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isSecurePasswordConfirmation =
                                    !isSecurePasswordConfirmation;
                              });
                            },
                            icon: Icon(
                              isSecurePasswordConfirmation
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: isSecurePasswordConfirmation,
                          validator: (passwordConfirmation) =>
                              ValidatorHelper.validatePasswordConfirmation(
                                passwordConfirmation,
                                emptyMessage: LocaleKeys
                                    .please_enter_your_password
                                    .tr(),
                                originalPassword: authController
                                    .passwordControllerForResetPassword
                                    .text,
                                notMatchMessage: LocaleKeys
                                    .passwords_do_not_match
                                    .tr(),
                              ),
                          controller: authController
                              .passwordConfirmationControllerForResetPassword,
                          hintText: LocaleKeys.confirm_new_password.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  isLoading: authState is ResetPasswordLoadingState,
                  buttonColor: AppColors.primaryColor,
                  buttonText: LocaleKeys.reset_password.tr(),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await authController.resetPassword();
                    }
                  },
                ).paddingAll(16.sp),
              ],
            );
          },
        ),
      ),
    );
  }
}
