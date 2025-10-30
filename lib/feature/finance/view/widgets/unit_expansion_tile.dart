import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_summary_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/installments_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

// class UnitExpansionTile extends StatelessWidget {
//   final Unit unit;
//   const UnitExpansionTile({super.key, required this.unit});

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(
//         unit.unitName ?? '',
//         style: AppStyle.fontSize18Bold(
//           context,
//         ).copyWith(color: AppColors.primaryColor),
//       ),
//       childrenPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
//       children: [
//         FinanceSummaryCard(unit: unit),
//         15.ph,
//         const InstallmentsTable(),
//       ],
//     );
//   }
// }

class UnitExpansionTile extends StatelessWidget {
  final Unit unit;
  const UnitExpansionTile({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      builder: (context, state) {
        final bool isLoading = state.maybeWhen(
          getFinanceLoading: () => true,
          orElse: () => false,
        );

        return Skeletonizer(
          enabled: isLoading,
          child: ExpansionTile(
            title: Text(
              unit.unitName ?? '',
              style: AppStyle.fontSize18Bold(context)
                  .copyWith(color: AppColors.primaryColor),
            ),
            childrenPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 10.h,
            ),
            children: [
              FinanceSummaryCard(unit: unit),
              15.ph,
              const InstallmentsTable(),
            ],
          ),
        );
      },
    );
  }
}


