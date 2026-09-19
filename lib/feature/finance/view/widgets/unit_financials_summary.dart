import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Contract total, paid, remaining and progress for one unit with a plan.
class UnitFinancialsSummary extends StatelessWidget {
  const UnitFinancialsSummary({super.key, required this.financials});

  final UnitFinancials financials;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AmountStat(
                label: LocaleKeys.contract_total.tr(),
                value: FinanceFormatter.money(financials.contractTotal),
              ),
            ),
            Text(
              LocaleKeys.paid_percentage.tr(
                args: [FinanceFormatter.percentage(financials.paidPercentage)],
              ),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        10.ph,
        FinanceProgressBar(value: financials.paidPercentage / 100),
        12.ph,
        Row(
          children: [
            Expanded(
              child: AmountStat(
                label: LocaleKeys.total_paid.tr(),
                value: FinanceFormatter.money(financials.totalPaid),
                valueColor: FinanceColors.paid,
              ),
            ),
            Container(width: 1, height: 30.h, color: surface.border),
            12.pw,
            Expanded(
              child: AmountStat(
                label: LocaleKeys.remaining_balance.tr(),
                value: FinanceFormatter.money(financials.remainingBalance),
              ),
            ),
          ],
        ),
        if (financials.overdueAmount > 0) ...[
          12.ph,
          OverdueBanner(
            message: LocaleKeys.overdue_amount_banner.tr(
              args: [FinanceFormatter.money(financials.overdueAmount)],
            ),
          ),
        ],
      ],
    );
  }
}
