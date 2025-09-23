import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.change_password.tr()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  21.ph,
                  CustomTextFormField(
                    hintText: LocaleKeys.current_password.tr(),
                  ),
                  24.ph,
                  CustomTextFormField(hintText: LocaleKeys.new_password.tr()),
                  24.ph,
                  CustomTextFormField(
                    hintText: LocaleKeys.confirm_new_password.tr(),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            buttonColor: AppColors.primaryColor,
            buttonText: LocaleKeys.update_password.tr(),
            onPressed: () {},
          ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
        ],
      ),
    );
  }
}
