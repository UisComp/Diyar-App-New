import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The contract split into Unit / Maintenance deposit / Club house.
/// Parts with a total of 0 are hidden.
class ComponentBreakdownCard extends StatelessWidget {
  const ComponentBreakdownCard({super.key, required this.financials});

  final UnitFinancials financials;

  static String _label(InstallmentType type) =>
      type == InstallmentType.installment
      ? LocaleKeys.type_unit.tr()
      : type.labelKey.tr();

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final components = financials.visibleComponents;
    if (components.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: surface.cardDecoration(),
      child: Column(
        children: [
          for (var i = 0; i < components.length; i++) ...[
            if (i > 0) Divider(height: 24.h, color: surface.border),
            _ComponentRow(
              label: _label(components[i].$1),
              component: components[i].$2,
            ),
          ],
        ],
      ),
    );
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({required this.label, required this.component});

  final String label;
  final ComponentBreakdown component;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: surface.textPrimary,
                ),
              ),
            ),
            Text(
              FinanceFormatter.money(component.total),
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: surface.textPrimary,
              ),
            ),
          ],
        ),
        8.ph,
        FinanceProgressBar(
          value: component.paidFraction,
          color: FinanceColors.paid,
        ),
        8.ph,
        Row(
          children: [
            Expanded(
              child: AmountStat(
                label: LocaleKeys.paid.tr(),
                value: FinanceFormatter.money(component.paid),
                valueColor: FinanceColors.paid,
              ),
            ),
            Expanded(
              child: AmountStat(
                label: LocaleKeys.remaining.tr(),
                value: FinanceFormatter.money(component.remaining),
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
