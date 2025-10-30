import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinanceSummaryCard extends StatelessWidget {
  const FinanceSummaryCard({super.key, required this.unit});
  final Unit unit;

  @override
  Widget build(BuildContext context) {
    Widget buildRow(String title, String value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRow(
            LocaleKeys.total_installments.tr(),
            unit.financials?.installmentsCount.toString() ?? '0',
          ),
          buildRow(
            LocaleKeys.remaining_installments.tr(),
            unit.financials?.paymentStatistics?.pendingInstallments
                    .toString() ??
                '0',
          ),
          buildRow(
            LocaleKeys.remaining_value.tr(),
            unit.financials?.remainingBalance.toString() ?? '0',
          ),
          buildRow(
            LocaleKeys.total_value.tr(),
            unit.financials?.totalAfterInterest.toString() ?? '0',
          ),
          buildRow(
            LocaleKeys.paid.tr(),
            unit.financials?.totalPaid.toString() ?? '0',
          ),
        ],
      ),
    );
  }
}
