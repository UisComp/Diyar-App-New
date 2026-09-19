import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/awaiting_plan_view.dart';
import 'package:diyar_app/feature/finance/view/widgets/component_breakdown_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_state_views.dart';
import 'package:diyar_app/feature/finance/view/widgets/installment_counts_row.dart';
import 'package:diyar_app/feature/finance/view/widgets/installment_tile.dart';
import 'package:diyar_app/feature/finance/view/widgets/next_payment_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_financials_summary.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Opens a unit's payment plan either by [unitId] (from the finance tab) or
/// by [installmentId] (from a payment/overdue notification; there is no
/// single-installment endpoint, so the unit is found in `/user/finance`).
class UnitPaymentPlanArgs {
  const UnitPaymentPlanArgs({this.unitId, this.installmentId, this.controller})
    : assert(unitId != null || installmentId != null);

  final int? unitId;
  final int? installmentId;

  /// Reuses already-loaded data when opened from the finance tab.
  final FinanceController? controller;
}

class UnitPaymentPlanScreen extends StatelessWidget {
  const UnitPaymentPlanScreen({super.key, required this.args});

  final UnitPaymentPlanArgs args;

  @override
  Widget build(BuildContext context) {
    final controller = args.controller;
    if (controller != null && !controller.isClosed) {
      return BlocProvider.value(
        value: controller,
        child: _UnitPaymentPlanView(args: args),
      );
    }
    return BlocProvider(
      create: (_) => FinanceController()..getFinance(),
      child: _UnitPaymentPlanView(args: args),
    );
  }
}

class _UnitPaymentPlanView extends StatefulWidget {
  const _UnitPaymentPlanView({required this.args});

  final UnitPaymentPlanArgs args;

  @override
  State<_UnitPaymentPlanView> createState() => _UnitPaymentPlanViewState();
}

class _UnitPaymentPlanViewState extends State<_UnitPaymentPlanView> {
  final _highlightKey = GlobalKey();
  bool _scrolledToHighlight = false;

  FinanceUnit? _findUnit(FinancialData? data) {
    if (data == null) return null;
    final args = widget.args;
    if (args.installmentId != null) {
      return data.unitForInstallment(args.installmentId!);
    }
    return data.unitById(args.unitId!);
  }

  void _scrollToHighlightOnce() {
    if (_scrolledToHighlight || widget.args.installmentId == null) return;
    _scrolledToHighlight = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _highlightKey.currentContext;
      if (target != null && target.mounted) {
        Scrollable.ensureVisible(
          target,
          alignment: 0.3,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      builder: (context, state) {
        final controller = FinanceController.get(context);
        final unit = _findUnit(controller.data);
        final isLoading =
            !controller.hasData &&
            (state is GetFinanceLoadingState || state is FinanceInitialState);

        Widget body;
        if (isLoading) {
          body = const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        } else if (unit == null) {
          body = ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              state is GetFinanceFailureState && !controller.hasData
                  ? FinanceMessageView.error(onRetry: controller.getFinance)
                  : FinanceMessageView(
                      icon: Icons.search_off_rounded,
                      message: LocaleKeys.payment_not_found.tr(),
                    ),
            ],
          );
        } else {
          _scrollToHighlightOnce();
          body = _PlanContent(
            unit: unit,
            highlightedInstallmentId: widget.args.installmentId,
            highlightKey: _highlightKey,
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            titleAppBar: (unit?.label.isNotEmpty ?? false)
                ? unit!.label
                : LocaleKeys.payment_plan.tr(),
          ),
          body: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => controller.getFinance(silent: true),
            child: body,
          ),
        );
      },
    );
  }
}

class _PlanContent extends StatelessWidget {
  const _PlanContent({
    required this.unit,
    required this.highlightKey,
    this.highlightedInstallmentId,
  });

  final FinanceUnit unit;
  final int? highlightedInstallmentId;
  final GlobalKey highlightKey;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final financials = unit.financials;

    if (!unit.hasPaymentPlan || financials == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        children: const [AwaitingPlanView()],
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: surface.cardDecoration(),
            child: UnitFinancialsSummary(financials: financials),
          ),
          if (financials.nextInstallment != null) ...[
            12.ph,
            NextPaymentCard(installment: financials.nextInstallment!),
          ],
          if (financials.visibleComponents.isNotEmpty) ...[
            18.ph,
            FinanceSectionTitle(title: LocaleKeys.contract_breakdown.tr()),
            ComponentBreakdownCard(financials: financials),
          ],
          18.ph,
          FinanceSectionTitle(
            title: LocaleKeys.payment_schedule.tr(),
            trailing: Text(
              '${financials.installmentCounts.total}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: surface.textSecondary,
              ),
            ),
          ),
          InstallmentCountsRow(counts: financials.installmentCounts),
          12.ph,
          for (final installment in unit.installments)
            InstallmentTile(
              key: installment.id == highlightedInstallmentId
                  ? highlightKey
                  : ValueKey(installment.id),
              installment: installment,
              highlighted: installment.id == highlightedInstallmentId,
            ),
        ],
      ),
    );
  }
}
