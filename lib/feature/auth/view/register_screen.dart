import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/auth/view/widgets/already_have_account_with_sign_in.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
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
                        LocaleKeys.create_account.tr(),
                        style: AppStyle.fontSize22Bold.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      24.ph,
                      //! name
                      CustomTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) => ValidatorHelper.validateEmail(
                          name,
                          emptyMessage: LocaleKeys.please_enter_your_name.tr(),
                          invalidMessage: LocaleKeys.please_enter_valid_name
                              .tr(),
                        ),
                        contentPadding: EdgeInsets.all(20.sp),
                        controller: TextEditingController(),
                        labelText: LocaleKeys.name.tr(),
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.blackColor,
                        ),
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
                      24.ph,
                      CustomTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) =>
                            ValidatorHelper.validatePhoneOrPassword(
                              password,
                              emptyMessage: LocaleKeys.please_enter_your_phone
                                  .tr(),
                              spaceMessage: LocaleKeys.please_enter_valid_phone
                                  .tr(),
                            ),
                        contentPadding: EdgeInsets.all(20.sp),
                        controller: TextEditingController(),
                        labelText: LocaleKeys.contact_mobile_number.tr(),
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          color: AppColors.blackColor,
                        ),
                      ),
                      24.ph,
                      CustomButton(
                        buttonHeight: 50.h,
                        buttonText: LocaleKeys.sign_up.tr(),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {}
                        },
                        buttonColor: AppColors.primaryColor,
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
