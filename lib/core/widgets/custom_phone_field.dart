import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// A phone number with a country-code picker (Egypt by default). Read the
/// number as `controller.value.international`, e.g. `+201012345678`.
class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    this.controller,
    this.enabled = true,
    this.hintText,
    this.isEdit = false,
    this.textInputAction,
  });

  /// Countries listed first in the picker.
  static const favoriteCountries = [
    IsoCode.EG,
    IsoCode.SA,
    IsoCode.AE,
    IsoCode.KW,
    IsoCode.QA,
    IsoCode.BH,
    IsoCode.OM,
    IsoCode.JO,
  ];

  /// Read-only display: no validation.
  final bool? isEdit;
  final PhoneController? controller;
  final bool? enabled;
  final String? hintText;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final isEnabled = enabled ?? true;
    final validate = !(isEdit ?? false);
    final radius = BorderRadius.all(Radius.circular(14.r));
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
          borderRadius: radius,
        );

    // Numbers read left to right in both languages: keep "+20" on the left.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PhoneFormField(
        controller: controller,
        enabled: isEnabled,
        isCountrySelectionEnabled: isEnabled,
        keyboardType: TextInputType.phone,
        textInputAction: textInputAction,
        autofillHints: const [AutofillHints.telephoneNumber],
        shouldLimitLengthByCountry: true,
        cursorColor: AppColors.primaryColor,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: surface.textPrimary,
          letterSpacing: 0.5,
        ),
        countryButtonStyle: CountryButtonStyle(
          showFlag: true,
          showDialCode: true,
          showDropdownIcon: isEnabled,
          flagSize: 18.sp,
          padding: EdgeInsets.only(left: 14.w, right: 4.w),
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: surface.textPrimary,
          ),
        ),
        countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
          favorites: favoriteCountries,
          showDialCode: true,
          searchAutofocus: false,
          noResultMessage: LocaleKeys.no_country_found.tr(),
          backgroundColor: surface.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: surface.isDark
              ? const Color(0xFF111418)
              : AppColors.secondaryColor,
          hintText: hintText ?? LocaleKeys.contact_mobile_number.tr(),
          hintStyle: TextStyle(fontSize: 14.sp, color: surface.textSecondary),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: border(surface.border),
          enabledBorder: border(surface.border),
          disabledBorder: border(surface.border),
          errorBorder: border(AppColors.redColor),
          focusedBorder: border(AppColors.primaryColor, 1.6),
          focusedErrorBorder: border(AppColors.redColor, 1.6),
          helperMaxLines: 3,
          errorMaxLines: 3,
        ),
        validator: validate
            ? PhoneValidator.compose([
                PhoneValidator.required(
                  context,
                  errorText: LocaleKeys.please_enter_your_phone.tr(),
                ),
                PhoneValidator.validMobile(
                  context,
                  errorText: LocaleKeys.valid_phone_number.tr(),
                ),
              ])
            : null,
        autovalidateMode: validate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
      ).paddingSymmetric(horizontal: 16.w),
    );
  }
}
