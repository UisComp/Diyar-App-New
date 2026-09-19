import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The earliest row that is neither paid nor overdue. Shows what is still
/// owed on it (`remaining_amount`), not its full amount.
class NextPaymentCard extends StatelessWidget {
  const NextPaymentCard({super.key, required this.installment});

  final Installment installment;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.event_available_rounded,
              color: AppColors.primaryColor,
              size: 22.sp,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${LocaleKeys.next_payment.tr()} · ${installment.type.labelKey.tr()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: surface.textSecondary,
                  ),
                ),
                2.ph,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    FinanceFormatter.money(installment.remainingAmount),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: surface.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                FinanceFormatter.date(context, installment.dueDate),
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: surface.textPrimary,
                ),
              ),
              2.ph,
              Text(
                FinanceFormatter.dueLabel(context, installment),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
