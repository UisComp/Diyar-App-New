import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Totals across every unit that has a payment plan.
class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key, required this.summary});

  final FinancialSummary summary;

  @override
  Widget build(BuildContext context) {
    const onGradient = AppColors.whiteColor;
    final muted = AppColors.whiteColor.withValues(alpha: 0.72);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: AppColors.brandHeaderGradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contract_total.tr(),
            style: TextStyle(color: muted, fontSize: 13.sp),
          ),
          4.ph,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              FinanceFormatter.money(summary.totalContractValue),
              style: TextStyle(
                color: onGradient,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          16.ph,
          FinanceProgressBar(
            value: summary.overallPaidPercentage / 100,
            color: AppColors.accentHoverColor,
            backgroundColor: AppColors.whiteColor.withValues(alpha: 0.18),
            height: 8.h,
          ),
          6.ph,
          Text(
            LocaleKeys.paid_percentage.tr(
              args: [
                FinanceFormatter.percentage(summary.overallPaidPercentage),
              ],
            ),
            style: TextStyle(color: muted, fontSize: 12.sp),
          ),
          14.ph,
          Row(
            children: [
              Expanded(
                child: AmountStat(
                  label: LocaleKeys.total_paid.tr(),
                  value: FinanceFormatter.money(summary.totalPaid),
                  labelColor: muted,
                  valueColor: onGradient,
                ),
              ),
              12.pw,
              Expanded(
                child: AmountStat(
                  label: LocaleKeys.remaining_balance.tr(),
                  value: FinanceFormatter.money(summary.remainingBalance),
                  labelColor: muted,
                  valueColor: onGradient,
                ),
              ),
            ],
          ),
          if (summary.totalOverdueAmount > 0) ...[
            14.ph,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: FinanceColors.overdue.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: onGradient,
                    size: 18.sp,
                  ),
                  8.pw,
                  Expanded(
                    child: Text(
                      LocaleKeys.overdue_portfolio_banner.tr(
                        args: [
                          FinanceFormatter.money(summary.totalOverdueAmount),
                          '${summary.unitsWithOverdue}',
                        ],
                      ),
                      style: TextStyle(
                        color: onGradient,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
