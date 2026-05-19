import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/brand_logo_header.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/already_have_account_with_sign_in.dart';
import 'package:diyar_app/feature/auth/view/widgets/user_text_form_field_with_register_button.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BrandLogoHeader(
                        height: 240.h,
                        logoHeight: 150.h,
                        borderRadius: 28,
                      ),
                      28.ph,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: AppText(
                          LocaleKeys.create_account.tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize22Bold(context).copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      6.ph,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: AppText(
                          LocaleKeys.by_continue.tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize16Regular(context).copyWith(
                            fontSize: 13.sp,
                            color: AppColors.lightTextSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      20.ph,
                      const UserTextFormFieldForRegister(),
                      24.ph,
                      BlocBuilder<AuthController, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is RegisterLoadingState;
                          final authController = AuthController.get(context);
                          return CustomButton(
                            buttonHeight: 50.h,
                            buttonText: LocaleKeys.sign_up.tr(),
                            isLoading: isLoading,
                            onPressed: () async {
                              if (!isLoading &&
                                  formKey.currentState!.validate()) {
                                await authController.register();
                              }
                            },
                            buttonColor: AppColors.primaryColor,
                          );
                        },
                      ).paddingSymmetric(horizontal: 16.sp),
                      16.ph,
                      const AlreadyHaveAccountWithSignIn(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
