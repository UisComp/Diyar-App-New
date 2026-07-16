import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignedByFooter extends StatelessWidget {
  const DesignedByFooter({
    super.key,
    this.padding,
    this.compact = false,
    this.showLogo = false,
  });

  /// Diyar logo shown inside the branded badge.
  static const String _logoAsset = 'assets/images/diyar_new.png';

  /// Outer padding around the footer.
  final EdgeInsetsGeometry? padding;

  /// When true, drops the leading dot accent and uses smaller text — useful
  /// inside tight footers (e.g. login form bottom).
  final bool compact;

  /// When true, renders the modern branded variant: the Diyar logo inside a
  /// brand-colored badge wrapped in a subtle pill next to the credit text.
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final fontSize = compact ? 11.sp : 12.sp;

    if (showLogo) return _brandedVariant(mutedColor, fontSize);

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          AppText(
            LocaleKeys.designed_by.tr(),
            style: TextStyle(
              color: mutedColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: 4.w),
          AppText(
            LocaleKeys.diyar_co.tr(),
            style: TextStyle(
              color: AppColors.diyarColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Modern branded footer: [ logo badge ] · Designed by Diyar Co.
  Widget _brandedVariant(Color mutedColor, double fontSize) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            LocaleKeys.designed_by.tr(),
            style: TextStyle(
              color: mutedColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: 4.w),
          AppText(
            LocaleKeys.diyar_co.tr(),
            style: TextStyle(
              color: AppColors.diyarColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.diyarColor.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                _logoAsset,
                height: 28.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
