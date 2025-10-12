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
import 'package:go_router/go_router.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late AuthController authController;
  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
  }

  @override
  void dispose() {
    super.dispose();
    authController.close();
  }

  static final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.forget_password.tr().replaceAll("?", ""),
      ),
      body: BlocConsumer<AuthController, AuthState>(
        listener: (context, authState) {
          if (authState is ForgetPasswordSuccessState) {
            AppFunctions.successMessage(
              context,
              message:
                  authController.forgetPasswordResponseModel.message ??
                  LocaleKeys.message_sent_password_successfully.tr(),
            );
            context.push(RoutesName.otpScreen);
          }
          if (authState is ForgetPasswordFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  authController.forgetPasswordResponseModel.message ??
                  LocaleKeys.message_sent_password_failed.tr(),
            );
          }
        },
        builder: (context, authState) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.forgetPassword.image(),
                CustomTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => ValidatorHelper.validateEmail(
                    email,
                    emptyMessage: LocaleKeys.please_enter_your_email.tr(),
                    invalidMessage: LocaleKeys.please_enter_a_valid_email.tr(),
                  ),
                  hintText: LocaleKeys.email.tr(),
                  controller: authController.emailForForgetPasswordController,
                ),
                40.ph,
                CustomButton(
                  isLoading: authState is ForgetPasswordLoadingState,
                  buttonColor: AppColors.primaryColor,
                  buttonText: LocaleKeys.forget_password.tr().replaceAll(
                    "?",
                    "",
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await authController.forgetPassword();
                    }
                  },
                ).paddingSymmetric(horizontal: 16.w),
              ],
            ).paddingSymmetric(horizontal: 16.w),
          );
        },
      ),
    );
  }
}
