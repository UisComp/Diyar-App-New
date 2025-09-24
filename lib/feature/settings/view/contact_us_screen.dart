import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.contact_us.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.ph,
            Text(
              LocaleKeys.we_are_here_to_help.tr(),
              style: AppStyle.fontSize22Bold.copyWith(fontSize: 24.sp),
            ).paddingSymmetric(horizontal: 16.w),
            12.ph,
            Text(
              LocaleKeys.desc_we_are_here_to_help.tr(),
              style: AppStyle.fontSize16Regular,
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: 16.w),
            28.ph,
            Text(
              LocaleKeys.contact_form.tr(),
              style: AppStyle.fontSize22Bold.copyWith(fontSize: 24.sp),
            ).paddingSymmetric(horizontal: 16.w),
            20.ph,
            CustomTextFormField(
              hintText: LocaleKeys.your_name.tr(),
              keyboardType: TextInputType.name,
            ),
            24.ph,
            CustomTextFormField(
              hintText: LocaleKeys.your_email.tr(),
              keyboardType: TextInputType.name,
            ),
            24.ph,
            CustomTextFormField(
              maxLines: 10,
              isDense: true,
            ),
            24.ph,
            CustomButton(
              buttonColor: AppColors.primaryColor,
              buttonText: LocaleKeys.submit.tr(),
              onPressed: () {
                context.pop();
              },
            ).paddingSymmetric(horizontal: 16.w),
            28.ph,
            Text(
              LocaleKeys.other_contact_methods.tr(),
              style: AppStyle.fontSize22Bold.copyWith(fontSize: 18.sp),
            ).paddingSymmetric(horizontal: 16.w),
            CustomContainerInformation(
              titleContainer: LocaleKeys.email.tr(),
              descriptionContainer: 'eyadmohamed@gmail.com',
              svgIcon: Assets.images.svg.contactUs,
            ),
            24.ph,
            CustomContainerInformation(
              titleContainer: LocaleKeys.phone.tr(),
              descriptionContainer: '+201010076119',
              svgIcon: Assets.images.svg.phoneCall,
            ),
          ],
        ),
      ),
    );
  }
}
