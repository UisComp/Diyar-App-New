import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static Color _getPrimaryTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkTextPrimary
      : AppColors.lightTextPrimary;

  static Color _getSecondaryTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  static TextStyle fontSize22Bold(BuildContext context) => TextStyle(
    color: _getPrimaryTextColor(context),
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static TextStyle fontSize18Bold(BuildContext context) => TextStyle(
    color: _getPrimaryTextColor(context),
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle fontSize16Regular(BuildContext context) => TextStyle(
    color: _getSecondaryTextColor(context),
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle fontSize22BoldNewsReader(BuildContext context) => TextStyle(
    color: _getPrimaryTextColor(context),
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Newsreader',
  );

  static TextStyle fontSize14RegularNewsReader(BuildContext context) =>
      TextStyle(
        color: _getSecondaryTextColor(context),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Newsreader',
      );
}
