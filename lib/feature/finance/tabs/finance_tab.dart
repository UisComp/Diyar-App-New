import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_expansion_tile.dart';

class FinanceTab extends StatelessWidget {
  final List<Unit> units;
  const FinanceTab({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 80.sp,
                color: AppColors.primaryColor.withOpacity(0.5),
              ),
             16.ph,
              Text(
                "لا توجد بيانات مالية متاحة حالياً",
                style: AppStyle.fontSize16Regular(
                  context,
                ).copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: units.length,
      itemBuilder: (context, index) {
        return UnitExpansionTile(unit: units[index]);
      },
    );
  }
}
