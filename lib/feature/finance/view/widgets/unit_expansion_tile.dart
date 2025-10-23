import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_summary_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/installments_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnitExpansionTile extends StatelessWidget {
  final String unitName;
  const UnitExpansionTile({super.key, required this.unitName});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        unitName,
        style: AppStyle.fontSize18Bold(
          context,
        ).copyWith(color: AppColors.primaryColor),
      ),
      childrenPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      children: [const FinanceSummaryCard(), 15.ph, const InstallmentsTable()],
    );
  }
}
