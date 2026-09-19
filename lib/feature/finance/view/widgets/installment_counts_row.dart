import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Paid / partially paid / pending / overdue row counts for a plan.
class InstallmentCountsRow extends StatelessWidget {
  const InstallmentCountsRow({super.key, required this.counts});

  final InstallmentCounts counts;

  @override
  Widget build(BuildContext context) {
    final items = [
      (InstallmentStatus.paid, counts.paid),
      (InstallmentStatus.partiallyPaid, counts.partiallyPaid),
      (InstallmentStatus.pending, counts.pending),
      (InstallmentStatus.overdue, counts.overdue),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          Expanded(
            child: _CountTile(status: items[i].$1, count: items[i].$2),
          ),
        ],
      ],
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({required this.status, required this.count});

  final InstallmentStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = FinanceColors.forStatus(status);
    final surface = AppSurface.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: count > 0 ? 0.10 : 0.04),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: count > 0 ? color : surface.textSecondary,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              status.labelKey.tr(),
              maxLines: 1,
              style: TextStyle(fontSize: 11.sp, color: surface.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
