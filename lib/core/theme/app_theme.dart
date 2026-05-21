import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  static const String _fontFamily = 'Alexandria';

  static final ThemeData lightTheme = ThemeData(
    fontFamily: _fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentHoverColor,
      surface: AppColors.lightBackground,
    ),
    dividerColor: AppColors.dividerColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.lightBackground,
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
      ),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.lightTextPrimary,
        fontSize: 14.sp,
      ),
    ),
    cardColor: AppColors.lightCard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return AppColors.accentHoverColor;
          }
          return AppColors.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.whiteColor),
        overlayColor: WidgetStateProperty.all(
          AppColors.accentHoverColor.withValues(alpha: 0.18),
        ),
      ),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    fontFamily: _fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentHoverColor,
      surface: AppColors.darkBackground,
    ),
    dividerColor: AppColors.dividerColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBackground,
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
      ),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.darkTextPrimary,
        fontSize: 14.sp,
      ),
    ),
    cardColor: AppColors.darkCard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return AppColors.accentHoverColor;
          }
          return AppColors.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.whiteColor),
        overlayColor: WidgetStateProperty.all(
          AppColors.accentHoverColor.withValues(alpha: 0.22),
        ),
      ),
    ),
  );
}
