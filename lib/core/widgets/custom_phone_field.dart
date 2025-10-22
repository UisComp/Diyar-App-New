import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    this.controller,
    this.enabled = true,
    this.hintText,
    this.isEdit = false,
  });

  final bool? isEdit;
  final PhoneController? controller;
  final bool? enabled;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        AppThemeController.get(context).currentThemeMode == AppThemeMode.dark;
    return Tooltip(
      enableTapToDismiss: true,
      triggerMode: TooltipTriggerMode.tap,
      message: LocaleKeys.tool_tip_phone_number.tr(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PhoneFormField(
          cursorColor: AppColors.primaryColor,
          controller: controller,
          enabled: enabled!,

          decoration: InputDecoration(
            filled: true,
            fillColor: darkTheme ? AppColors.black87 : AppColors.secondaryColor,
            hintText: hintText ?? LocaleKeys.contact_mobile_number.tr(),
            hintTextDirection: TextDirection.ltr,
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
          validator: (isEdit == null || !isEdit!)
              ? PhoneValidator.compose([
                  PhoneValidator.required(context),
                  PhoneValidator.validMobile(context),
                ])
              : null,
          countrySelectorNavigator: CountrySelectorNavigator.bottomSheet(
            noResultMessage: LocaleKeys.no_country_found.tr(),
          ),
          isCountrySelectionEnabled: true,
          autovalidateMode: (isEdit == null || !isEdit!)
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
        ).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }
}
