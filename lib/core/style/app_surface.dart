import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Theme-aware card colors shared by the settings, notification, finance and
/// documents cards.
class AppSurface {
  const AppSurface._(this.isDark);

  factory AppSurface.of(BuildContext context) =>
      AppSurface._(Theme.of(context).brightness == Brightness.dark);

  final bool isDark;

  Color get card => isDark ? const Color(0xFF111418) : AppColors.whiteColor;
  Color get border =>
      isDark ? const Color(0xFF1F242B) : const Color(0xFFE5E9F0);
  Color get subtle =>
      isDark ? const Color(0xFF1A1F26) : const Color(0xFFF6F8FB);
  Color get textPrimary =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get textSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  BoxDecoration cardDecoration({double? radius, Color? borderColor}) =>
      BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(radius ?? 16.r),
        border: Border.all(color: borderColor ?? border, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      );
}
