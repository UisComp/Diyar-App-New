import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_refresh_notifier.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/unit_payment_plan_screen.dart';
import 'package:diyar_app/feature/finance/view/widgets/installment_tile.dart';
import 'package:diyar_app/feature/finance/view/widgets/portfolio_summary_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_finance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/finance_fixtures.dart';
import '../helpers/test_app.dart';

FinancialData _data() =>
    FinanceResponseModel.fromJson(financeResponseJson()).data!;

Installment _row(int id) =>
    _data().units.first.installments.firstWhere((i) => i.id == id);

FinanceController _loadedController() => FinanceController()
  ..financeResponseModel = FinanceResponseModel.fromJson(financeResponseJson());

Widget _scroll(Widget child) =>
    SingleChildScrollView(padding: const EdgeInsets.all(16), child: child);

void main() {
  group('UnitFinanceCard', () {
    testWidgets('unit with a plan shows totals, overdue banner, next payment', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        _scroll(UnitFinanceCard(unit: _data().units.first, onTap: () {})),
      );

      expect(find.text('Block 1 · B1-G-01'), findsOneWidget);
      expect(find.text("La'Mer Residences  •  Block"), findsOneWidget);
      expect(find.text('3,300,000.00 EGP'), findsOneWidget);
      expect(find.text('1,150,000.00 EGP'), findsOneWidget);
      expect(find.text('2,150,000.00 EGP'), findsOneWidget);
      expect(find.text('34.85% paid'), findsOneWidget);
      expect(find.text('You have 200,000.00 EGP overdue'), findsOneWidget);
      // Next payment shows what is still owed, not the full row amount.
      expect(find.text('650,000.00 EGP'), findsOneWidget);
      expect(find.text('900,000.00 EGP'), findsNothing);
      expect(find.text('Due in 13 days'), findsOneWidget);
      expect(find.text('View payment plan'), findsOneWidget);
    });

    testWidgets('unit without a plan shows the empty state, not money owed', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        _scroll(UnitFinanceCard(unit: _data().units.last, onTap: () {})),
      );

      expect(find.text('Your payment plan is being prepared'), findsOneWidget);
      expect(find.text('Remaining balance'), findsNothing);
      expect(find.text('2,700,000.00 EGP'), findsNothing);
      expect(find.text('View payment plan'), findsNothing);
    });
  });

  testWidgets('PortfolioSummaryCard shows totals and the overdue banner', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      _scroll(PortfolioSummaryCard(summary: _data().financialSummary!)),
    );

    expect(find.text('3,300,000.00 EGP'), findsOneWidget);
    expect(find.text('34.85% paid'), findsOneWidget);
    expect(find.text('200,000.00 EGP overdue on 1 unit(s)'), findsOneWidget);
  });

  group('InstallmentTile', () {
    testWidgets('paid row shows the paid date and full amount', (tester) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(1))),
      );

      expect(find.text('Down payment'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Paid on 1 Jun 2026'), findsOneWidget);
      expect(find.text('600,000.00 EGP'), findsOneWidget);
    });

    testWidgets('partially paid row shows progress and remaining amount', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(3))),
      );

      expect(find.text('Partially paid'), findsOneWidget);
      expect(find.text('Due in 13 days'), findsOneWidget);
      expect(find.text('650,000.00 EGP'), findsOneWidget);
      expect(find.text('250,000.00 of 900,000.00 EGP paid'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('row flagged is_overdue displays as overdue', (tester) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(2))),
      );

      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('Partially paid'), findsNothing);
      expect(find.text('3 days overdue'), findsOneWidget);
      expect(find.text('200,000.00 EGP'), findsOneWidget);
      expect(find.text('100,000.00 of 300,000.00 EGP paid'), findsOneWidget);
    });

    testWidgets('row due today is pending, not overdue', (tester) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(4))),
      );

      expect(find.text('Maintenance deposit'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Due today'), findsOneWidget);
    });

    testWidgets('tapping a row opens its payments', (tester) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(3))),
      );

      await tester.tap(find.byType(InstallmentTile));
      await tester.pumpAndSettle();

      expect(find.text('Installment #3'), findsOneWidget);
      expect(find.text('Payments'), findsOneWidget);
      expect(find.text('15 Sep 2026  •  Cheque'), findsOneWidget);
      expect(find.text('Receipt no. RC-260918-TFWQVO'), findsOneWidget);
    });

    testWidgets('payments sheet shows an empty state', (tester) async {
      await pumpLocalized(
        tester,
        _scroll(InstallmentTile(installment: _row(4))),
      );

      await tester.tap(find.byType(InstallmentTile));
      await tester.pumpAndSettle();

      expect(find.text('No payments recorded yet'), findsOneWidget);
    });
  });

  group('UnitPaymentPlanScreen', () {
    testWidgets('opened from a notification finds the unit by installment', (
      tester,
    ) async {
      final controller = _loadedController();
      addTearDown(controller.close);

      await pumpLocalized(
        tester,
        UnitPaymentPlanScreen(
          args: UnitPaymentPlanArgs(installmentId: 4, controller: controller),
        ),
        wrapInScaffold: false,
      );

      expect(find.text('Block 1 · B1-G-01'), findsOneWidget);
      expect(find.text('Contract breakdown'), findsOneWidget);
      expect(find.text('Club house'), findsOneWidget);
      expect(find.text('Payment schedule'), findsOneWidget);
      expect(find.byType(InstallmentTile), findsNWidgets(4));

      final highlighted = tester.widget<InstallmentTile>(
        find.byWidgetPredicate((w) => w is InstallmentTile && w.highlighted),
      );
      expect(highlighted.installment.id, 4);
    });

    testWidgets('unknown installment id shows a friendly message', (
      tester,
    ) async {
      final controller = _loadedController();
      addTearDown(controller.close);

      await pumpLocalized(
        tester,
        UnitPaymentPlanScreen(
          args: UnitPaymentPlanArgs(installmentId: 999, controller: controller),
        ),
        wrapInScaffold: false,
      );

      expect(
        find.text("We couldn't find this payment. It may have been updated."),
        findsOneWidget,
      );
    });

    testWidgets('unit without a plan shows the empty state', (tester) async {
      final controller = _loadedController();
      addTearDown(controller.close);

      await pumpLocalized(
        tester,
        UnitPaymentPlanScreen(
          args: UnitPaymentPlanArgs(unitId: 2, controller: controller),
        ),
        wrapInScaffold: false,
      );

      expect(find.text('Your payment plan is being prepared'), findsOneWidget);
      expect(find.byType(InstallmentTile), findsNothing);
    });

    testWidgets('renders in Arabic with admin-panel labels', (tester) async {
      final controller = _loadedController();
      addTearDown(controller.close);

      await pumpLocalized(
        tester,
        UnitPaymentPlanScreen(
          args: UnitPaymentPlanArgs(unitId: 1, controller: controller),
        ),
        locale: const Locale('ar'),
        wrapInScaffold: false,
      );

      expect(find.text('جدول الدفعات'), findsOneWidget);
      expect(find.text('مقدم'), findsOneWidget);
      expect(find.text('وديعة الصيانة'), findsWidgets);
      expect(find.text('متأخر 3 أيام'), findsOneWidget);
      expect(find.text('مستحق خلال 13 يومًا'), findsWidgets);
      expect(find.text('مستحق اليوم'), findsWidgets);
      expect(find.text('3,300,000.00 ج.م'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('FinanceController', () {
    test('a failed refresh keeps the data already on screen', () async {
      final controller = _loadedController();
      addTearDown(controller.close);

      // No API client in tests, so the request fails.
      FinanceRefreshNotifier.instance.requestRefresh();
      await controller.stream.firstWhere((s) => s is GetFinanceFailureState);

      expect(controller.hasData, isTrue);
      expect(controller.data!.units, hasLength(2));
    });

    test('initial load failure reports an error', () async {
      final controller = FinanceController();
      addTearDown(controller.close);

      await controller.getFinance();

      expect(controller.state, isA<GetFinanceFailureState>());
      expect(controller.hasData, isFalse);
    });

    test('stops listening for refreshes once closed', () async {
      final controller = FinanceController();
      await controller.close();
      // Must not throw "Cannot emit new states after calling close".
      FinanceRefreshNotifier.instance.requestRefresh();
    });
  });
}
