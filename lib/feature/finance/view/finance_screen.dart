import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/unit_payment_plan_screen.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_state_views.dart';
import 'package:diyar_app/feature/finance/view/widgets/portfolio_summary_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_finance_card.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Signed-in customers get the finance tab; guards and guests don't.
bool get canAccessFinance =>
    userModel?.data?.accessToken != null &&
    !(userModel?.data?.user.roles?.contains('guard') ?? false);

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isGuest = userModel?.data?.accessToken == null;

    if (isGuest) {
      return Scaffold(
        appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: CustomButton(
              buttonColor: AppColors.primaryColor,
              buttonText: LocaleKeys.login.tr(),
              onPressed: () => context.go(RoutesName.login),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => FinanceController()..getFinance(),
      child: BlocBuilder<LanguageController, LanguageState>(
        buildWhen: (previous, current) => current is ChangeCurrentLanguageState,
        builder: (context, _) => const _FinanceView(),
      ),
    );
  }
}

class _FinanceView extends StatelessWidget {
  const _FinanceView();

  @override
  Widget build(BuildContext context) {
    // The tab lives in an IndexedStack, so refresh quietly whenever the user
    // comes back to it.
    return BlocListener<HomeController, HomeState>(
      listenWhen: (previous, current) =>
          current is ChangeIndexBottomNavBarState &&
          HomeController.get(context).currentTab == AppTab.finance,
      listener: (context, _) =>
          FinanceController.get(context).getFinance(silent: true),
      child: Scaffold(
        appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
        body: BlocBuilder<FinanceController, FinanceState>(
          builder: (context, state) {
            final controller = FinanceController.get(context);
            final data = controller.data;

            if (data == null) {
              final isLoading =
                  state is GetFinanceLoadingState ||
                  state is FinanceInitialState;
              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: controller.getFinance,
                child: isLoading
                    ? const _FinanceSkeleton()
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          FinanceMessageView.error(
                            onRetry: controller.getFinance,
                          ),
                        ],
                      ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () => controller.getFinance(silent: true),
              child: _FinanceContent(data: data),
            );
          },
        ),
      ),
    );
  }
}

class _FinanceContent extends StatelessWidget {
  const _FinanceContent({required this.data});

  final FinancialData data;

  @override
  Widget build(BuildContext context) {
    final summary = data.financialSummary;
    final units = data.units;

    if (units.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          FinanceMessageView(
            icon: Icons.account_balance_wallet_outlined,
            message: LocaleKeys.no_finance_available.tr(),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        if (summary != null && summary.unitsWithPlan > 0) ...[
          PortfolioSummaryCard(summary: summary),
          18.ph,
        ],
        FinanceSectionTitle(
          title: LocaleKeys.your_units.tr(),
          trailing: summary != null && summary.unitsAwaitingPlan > 0
              ? Text(
                  LocaleKeys.units_awaiting_plan.tr(
                    args: ['${summary.unitsAwaitingPlan}'],
                  ),
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: AppSurface.of(context).textSecondary,
                  ),
                )
              : null,
        ),
        for (final unit in units)
          UnitFinanceCard(
            unit: unit,
            onTap: unit.unitId == null
                ? null
                : () => context.push(
                    RoutesName.unitPaymentPlanScreen,
                    extra: UnitPaymentPlanArgs(
                      unitId: unit.unitId,
                      controller: FinanceController.get(context),
                    ),
                  ),
          ),
      ],
    );
  }
}

class _FinanceSkeleton extends StatelessWidget {
  const _FinanceSkeleton();

  static const _fakeFinancials = UnitFinancials(
    contractTotal: 3300000,
    totalPaid: 1150000,
    remainingBalance: 2150000,
    paidPercentage: 34.85,
    hasPaymentPlan: true,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          const PortfolioSummaryCard(
            summary: FinancialSummary(
              totalContractValue: 3300000,
              totalPaid: 1150000,
              remainingBalance: 2150000,
              overallPaidPercentage: 34.85,
            ),
          ),
          18.ph,
          for (var i = 0; i < 2; i++)
            const UnitFinanceCard(
              unit: FinanceUnit(
                unitLabel: 'Block 1 · B1-G-01',
                financials: _fakeFinancials,
              ),
            ),
        ],
      ),
    );
  }
}
