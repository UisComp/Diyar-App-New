import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class FinanceColors {
  static const Color paid = Color(0xFF1E9E5A);
  static const Color partiallyPaid = AppColors.primaryColor;
  static const Color pending = Color(0xFFE69A00);
  static const Color overdue = Color(0xFFD93025);
  static const Color unknown = AppColors.greyColor;

  static Color forStatus(InstallmentStatus status) => switch (status) {
    InstallmentStatus.paid => paid,
    InstallmentStatus.partiallyPaid => partiallyPaid,
    InstallmentStatus.pending => pending,
    InstallmentStatus.overdue => overdue,
    InstallmentStatus.unknown => unknown,
  };
}

class FinanceProgressBar extends StatelessWidget {
  const FinanceProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primaryColor,
    this.backgroundColor,
    this.height,
  });

  /// 0..1
  final double value;
  final Color color;
  final Color? backgroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1).toDouble(),
        minHeight: height ?? 6.h,
        color: color,
        backgroundColor: backgroundColor ?? AppSurface.of(context).border,
      ),
    );
  }
}

class InstallmentStatusChip extends StatelessWidget {
  const InstallmentStatusChip({super.key, required this.status});

  final InstallmentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = FinanceColors.forStatus(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.labelKey.tr(),
        style: TextStyle(
          color: color,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class OverdueBanner extends StatelessWidget {
  const OverdueBanner({super.key, required this.message, this.hint});

  final String message;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: FinanceColors.overdue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: FinanceColors.overdue.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: FinanceColors.overdue,
            size: 20.sp,
          ),
          8.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: FinanceColors.overdue,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hint != null) ...[
                  2.ph,
                  Text(
                    hint!,
                    style: TextStyle(
                      color: FinanceColors.overdue.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceSectionTitle extends StatelessWidget {
  const FinanceSectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 6.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          8.pw,
          Expanded(
            child: AppText(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppSurface.of(context).textPrimary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Label above a value, e.g. "Total paid" / "1,150,000.00 EGP".
class AmountStat extends StatelessWidget {
  const AmountStat({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.labelColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final Color? labelColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: labelColor ?? surface.textSecondary,
          ),
        ),
        2.ph,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? surface.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
