import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    this.controller,
    this.enabled = true,
  });

  final PhoneController? controller;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      enableTapToDismiss: true,
      triggerMode: TooltipTriggerMode.tap,
       message: LocaleKeys.tool_tip_phone_number.tr(),
      child: PhoneFormField(
        cursorColor: AppColors.primaryColor,
        controller: controller,
        enabled: enabled!,
        decoration: InputDecoration(
          helperMaxLines: 8,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
        ),
        validator: PhoneValidator.compose([
          PhoneValidator.required(context),
          PhoneValidator.validMobile(context),
        ]),
        countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
        isCountrySelectionEnabled: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ).paddingSymmetric(horizontal: 16.w),
    );
  }
}
