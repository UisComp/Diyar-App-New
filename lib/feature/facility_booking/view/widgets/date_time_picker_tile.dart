import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimePickerTile extends StatelessWidget {
  const DateTimePickerTile({
    super.key,
    required this.isDark,
    required this.label,
    required this.prefixLabel,
    required this.prefixColor,
    required this.icon,
    required this.iconColor,
    required this.dateTime,
    required this.onTap,
  });

  final bool isDark;
  final String label;
  final String prefixLabel;
  final Color prefixColor;
  final IconData icon;
  final Color iconColor;
  final DateTime? dateTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = dateTime == null;
    final Color borderColor = isEmpty
        ? Colors.redAccent.withOpacity(0.55)
        : AppColors.greyColor.withOpacity(0.3);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        label,
                        style: AppStyle.fontSize12Regular(
                          context,
                        ).copyWith(color: AppColors.greyColor),
                      ),
                      4.pw,
                      AppText(
                        '*',
                        style: AppStyle.fontSize12Bold(
                          context,
                        ).copyWith(color: Colors.redAccent),
                      ),
                    ],
                  ),
                  4.ph,
                  AppText(
                    dateTime != null
                        ? AppFormatter.formatDateWithTime(dateTime!)
                        : '-- / -- / ----   --:--',
                    style: AppStyle.fontSize14Regular(context).copyWith(
                      color: isEmpty
                          ? AppColors.greyColor
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                      fontWeight: isEmpty ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_calendar_outlined,
              size: 16.sp,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }
}
