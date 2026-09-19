import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/finance_fixtures.dart';

void main() {
  group('Installment', () {
    test('parses the documented partially-paid row', () {
      final i = Installment.fromJson(partiallyPaidInstallmentJson());

      expect(i.id, 3);
      expect(i.number, 3);
      expect(i.type, InstallmentType.installment);
      expect(i.amount, 900000);
      expect(i.paidAmount, 250000);
      expect(i.remainingAmount, 650000);
      expect(i.dueDate, DateTime(2026, 10, 1));
      expect(i.paidAt, isNull);
      expect(i.status, InstallmentStatus.partiallyPaid);
      expect(i.displayStatus, InstallmentStatus.partiallyPaid);
      expect(i.isOverdue, isFalse);
      expect(i.daysUntilDue, 13);
      expect(i.paidFraction, closeTo(0.2778, 0.0001));
      expect(i.unit?.label, 'Block 1 · B1-G-01');
      expect(i.unit?.building?.type, BuildingType.block);

      expect(i.payments, hasLength(1));
      final p = i.payments.single;
      expect(p.amount, 250000);
      expect(p.paidAt, DateTime(2026, 9, 15));
      expect(p.method, PaymentMethod.cheque);
      expect(p.receiptNo, 'RC-260918-TFWQVO');
    });

    test('dates are local calendar dates, never shifted to UTC', () {
      final i = Installment.fromJson(partiallyPaidInstallmentJson());
      expect(i.dueDate!.isUtc, isFalse);
      expect(i.dueDate!.hour, 0);
    });

    test('is_overdue wins over a stale status (nightly job lag)', () {
      final i = Installment.fromJson({
        ...partiallyPaidInstallmentJson(),
        'status': 'pending',
        'is_overdue': true,
        'days_until_due': -2,
      });
      expect(i.status, InstallmentStatus.pending);
      expect(i.displayStatus, InstallmentStatus.overdue);
    });

    test('parses int, double and (defensively) string money', () {
      final i = Installment.fromJson({
        'id': 1,
        'amount': 5000,
        'paid_amount': 1234.56,
        'remaining_amount': '3765.44',
      });
      expect(i.amount, 5000.0);
      expect(i.paidAmount, 1234.56);
      expect(i.remainingAmount, 3765.44);
    });

    test('unknown enum values fall back instead of crashing', () {
      final i = Installment.fromJson({
        'id': 9,
        'type': 'parking_fee',
        'status': 'refunded',
        'payments': [
          {'id': 1, 'amount': 1, 'paid_at': '2026-01-01', 'method': 'crypto'},
        ],
      });
      expect(i.type, InstallmentType.unknown);
      expect(i.status, InstallmentStatus.unknown);
      expect(i.payments.single.method, PaymentMethod.unknown);
    });

    test('tolerates missing optional fields', () {
      final i = Installment.fromJson({'id': 1});
      expect(i.payments, isEmpty);
      expect(i.isOverdue, isFalse);
      expect(i.daysUntilDue, isNull);
      expect(i.dueDate, isNull);
      expect(i.paidFraction, 0);
    });

    test('parses every documented enum value', () {
      expect(
        InstallmentType.parse('down_payment'),
        InstallmentType.downPayment,
      );
      expect(
        InstallmentType.parse('maintenance_deposit'),
        InstallmentType.maintenanceDeposit,
      );
      expect(InstallmentType.parse('club_house'), InstallmentType.clubHouse);
      expect(InstallmentStatus.parse('pending'), InstallmentStatus.pending);
      expect(InstallmentStatus.parse('paid'), InstallmentStatus.paid);
      expect(InstallmentStatus.parse('overdue'), InstallmentStatus.overdue);
      expect(PaymentMethod.parse('cash'), PaymentMethod.cash);
      expect(PaymentMethod.parse('bank_transfer'), PaymentMethod.bankTransfer);
      expect(PaymentMethod.parse('card'), PaymentMethod.card);
      expect(PaymentMethod.parse('other'), PaymentMethod.other);
    });
  });

  group('UnitFinancials', () {
    test('parses the documented financials', () {
      final f = UnitFinancials.fromJson(unitFinancialsJson());

      expect(f.unitValue, 3000000);
      expect(f.maintenanceDepositAmount, 240000);
      expect(f.clubHouseAmount, 60000);
      expect(f.contractTotal, 3300000);
      expect(f.hasPaymentPlan, isTrue);
      expect(f.totalPaid, 1150000);
      expect(f.remainingBalance, 2150000);
      expect(f.overdueAmount, 0);
      expect(f.paidPercentage, 34.85);

      expect(f.unitComponent!.paid, 1150000);
      expect(f.maintenanceDepositComponent!.remaining, 240000);
      expect(f.clubHouseComponent!.total, 60000);

      final c = f.installmentCounts;
      expect(c.total, 6);
      expect(c.paid + c.partiallyPaid + c.pending + c.overdue, c.total);

      expect(f.nextInstallment!.id, 3);
      expect(f.nextInstallment!.remainingAmount, 650000);
      expect(f.nextInstallment!.status, InstallmentStatus.partiallyPaid);
    });

    test('hides contract parts whose total is 0', () {
      final f = UnitFinancials.fromJson(unitFinancialsJson(clubHouseTotal: 0));
      expect(f.visibleComponents.map((c) => c.$1), [
        InstallmentType.installment,
        InstallmentType.maintenanceDeposit,
      ]);
    });

    test('parses a unit that has no payment plan yet', () {
      final f = UnitFinancials.fromJson(noPlanFinancialsJson());
      expect(f.hasPaymentPlan, isFalse);
      expect(f.nextInstallment, isNull);
      expect(f.installmentCounts.total, 0);
    });
  });

  group('FinanceResponseModel (GET /api/user/finance)', () {
    test('parses summary and every unit, including units without a plan', () {
      final model = FinanceResponseModel.fromJson(financeResponseJson());
      final data = model.data!;

      expect(model.success, isTrue);
      final s = data.financialSummary!;
      expect(s.totalUnits, 2);
      expect(s.unitsWithPlan, 1);
      expect(s.unitsAwaitingPlan, 1);
      expect(s.totalContractValue, 3300000);
      expect(s.overallPaidPercentage, 34.85);
      expect(s.totalOverdueAmount, 200000);
      expect(s.unitsWithOverdue, 1);

      expect(data.units, hasLength(2));
      final withPlan = data.units.first;
      expect(withPlan.unitId, 1);
      expect(withPlan.project?.name, "La'Mer Residences");
      expect(withPlan.hasPaymentPlan, isTrue);
      expect(withPlan.installments, hasLength(4));

      final awaiting = data.units.last;
      expect(awaiting.hasPaymentPlan, isFalse);
      expect(awaiting.project, isNull);
      expect(awaiting.installments, isEmpty);
    });

    test('finds the unit for a notification installment id', () {
      final data = FinanceResponseModel.fromJson(financeResponseJson()).data!;
      expect(data.unitForInstallment(4)?.unitId, 1);
      expect(data.unitForInstallment(999), isNull);
      expect(data.unitById(2)?.label, 'V-3');
    });

    test('tolerates a failed response with no data', () {
      final model = FinanceResponseModel.fromJson({
        'success': false,
        'message': 'Server error',
        'data': null,
      });
      expect(model.success, isFalse);
      expect(model.data, isNull);
    });
  });
}
