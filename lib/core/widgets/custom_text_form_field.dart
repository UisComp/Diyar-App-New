import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.validator,
    this.controller,
    this.labelText,
    this.keyboardType,
    this.helperText,
    this.helperStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.labelStyle,
    this.obscureText,
    this.contentPadding,
    this.autovalidateMode,
    this.hintText,
    this.hintStyle,
    this.isDense,
    this.maxLength,
    this.maxLines = 1,
    this.enabled,
    this.inputFormatters,
    this.readOnly=false,
    this.onTap,
  });
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextStyle? labelStyle;
  final bool? obscureText;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool? isDense;
  final int? maxLength;
  final int? maxLines;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool ?readOnly ;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final darkTheme =
        AppThemeController.get(context).currentThemeMode == AppThemeMode.dark;
    final Color fillColor =
        darkTheme ? const Color(0xFF111418) : AppColors.secondaryColor;
    final Color enabledBorderColor =
        darkTheme ? const Color(0xFF1F242B) : const Color(0xFFE3E7EE);
    final BorderRadius radius = BorderRadius.all(Radius.circular(14.r));
    return TextFormField(
      onTap:onTap,
      readOnly:readOnly?? false,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      cursorColor: AppColors.primaryColor,
      validator: validator,
      autovalidateMode: autovalidateMode,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: isDense,
        hintStyle: hintStyle ??
            AppStyle.fontSize16Regular(context).copyWith(
              color: darkTheme
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 14.sp,
            ),
        hintText: hintText ?? labelText,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        labelStyle: labelStyle ??
            AppStyle.fontSize16Regular(context).copyWith(
              color: darkTheme
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 13.sp,
            ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: prefixIcon,
        prefixIconColor: AppColors.primaryColor,
        suffixIcon: suffixIcon,
        suffixIconColor: darkTheme
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        enabled: enabled ?? true,
        helperText: helperText,
        helperStyle: helperStyle,
        fillColor: fillColor,
        filled: true,
        labelText: null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor),
          borderRadius: radius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor),
          borderRadius: radius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.redColor),
          borderRadius: radius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primaryColor, width: 1.6),
          borderRadius: radius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.redColor, width: 1.6),
          borderRadius: radius,
        ),
      ),
    ).paddingSymmetric(horizontal: 16.w);
  }
}
