import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/auth/view/widgets/dont_have_account_with_sign_up.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static final formKey = GlobalKey<FormState>();

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
                      Assets.images.diyarPmc
                          .image(
                            height: 270.h,
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          )
                          .paddingOnly(top: 20.h),
                      67.ph,
                      Text(
                        LocaleKeys.login_message.tr(),
                        style: AppStyle.fontSize16Regular,
                      ),
                      24.ph,
                      CustomTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) => ValidatorHelper.validateEmail(
                          email,
                          emptyMessage: LocaleKeys.please_enter_your_email.tr(),
                          invalidMessage: LocaleKeys.please_enter_a_valid_email
                              .tr(),
                        ),
                        contentPadding: EdgeInsets.all(20.sp),
                        controller: TextEditingController(),
                        labelText: LocaleKeys.email.tr(),
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.blackColor,
                        ),
                      ),
                      24.ph,
                      CustomTextFormField(
                        keyboardType: TextInputType.visiblePassword,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        contentPadding: EdgeInsets.all(20.sp),
                        controller: TextEditingController(),
                        labelText: LocaleKeys.password.tr(),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.visibility_off),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.blackColor,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {}
                        },
                        buttonColor: AppColors.primaryColor,
                      ).paddingSymmetric(horizontal: 16.sp),
                    ],
                  ),
                ),
              ),
            ),
            const DontHaveAccountWithSignUp(),
          ],
        ),
      ),
    );
  }
}
