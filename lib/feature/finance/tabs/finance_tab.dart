import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_expansion_tile.dart';

class FinanceTab extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const FinanceTab({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      buildWhen: (previous, current) => current.maybeWhen(
        getFinanceLoading: () => true,
        getFinanceSuccess: () => true,
        getFinanceFailure: (_) => true,
        orElse: () => false,
      ),
      builder: (context, state) {
        final units =
            FinanceController.get(context).financeResponseModel.data?.units ??
            [];

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: onRefresh ?? () async {},
          child: units.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
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
                                LocaleKeys.no_finance_available.tr(),
                                style: AppStyle.fontSize16Regular(
                                  context,
                                ).copyWith(color: Colors.grey.shade700),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    return UnitExpansionTile(unit: units[index]);
                  },
                ),
        );
      },
    );
  }
}
