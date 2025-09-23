import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.personal_information.tr()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.ph,
                  Text(LocaleKeys.name.tr()).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: 'Eyad',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                  24.ph,
                  Text(
                    LocaleKeys.email.tr(),
                    style: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: 'eyadmohamed@gmail.com',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                  24.ph,
                  Text(
                    LocaleKeys.contact_mobile_number.tr(),
                  ).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: '+201010076119',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            buttonColor: AppColors.primaryColor,
            buttonText: LocaleKeys.save_changes.tr(),
            onPressed: () {},
          ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
        ],
      ),
    );
  }
}
