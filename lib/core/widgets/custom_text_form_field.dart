import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        hintStyle: hintStyle,
        hintText: hintText,
        contentPadding: contentPadding,
        labelStyle:
            labelStyle ??
            AppStyle.fontSize16Regular.copyWith(color: AppColors.greyColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: true,
        helperText: helperText,
        helperStyle: helperStyle,
        fillColor: AppColors.secondaryColor,
        filled: true,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide:  BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: AppColors.primaryColor),
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
    ).paddingSymmetric(horizontal: 16.w);
  }
}
