import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/feature/finance/model/finance_enums.dart';

export 'package:diyar_app/core/model/building_models.dart';
export 'package:diyar_app/feature/finance/model/finance_enums.dart';

/// Money arrives as a JSON number (int for whole amounts, double otherwise).
/// Strings are tolerated defensively so a stray `"5000.00"` never crashes.
double parseMoney(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int? parseIntOrNull(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Parses a `YYYY-MM-DD` API date as a local calendar date (no timezone
/// conversion, per the API contract).
DateTime? parseApiDate(dynamic value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

List<Map<String, dynamic>> _asMapList(dynamic value) => value is List
    ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
    : const [];

/// Response of `GET /api/user/finance`.
class FinanceResponseModel {
  final bool? success;
  final String? message;
  final FinancialData? data;

  const FinanceResponseModel({this.success, this.message, this.data});

  factory FinanceResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return FinanceResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: data == null ? null : FinancialData.fromJson(data),
    );
  }
}

class FinancialData {
  final FinancialSummary? financialSummary;
  final List<FinanceUnit> units;

  const FinancialData({this.financialSummary, this.units = const []});

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    final summary = _asMap(json['financial_summary']);
    return FinancialData(
      financialSummary: summary == null
          ? null
          : FinancialSummary.fromJson(summary),
      units: _asMapList(json['units']).map(FinanceUnit.fromJson).toList(),
    );
  }

  /// Finds the unit whose plan contains [installmentId], used to deep-link
  /// from payment/overdue notifications.
  FinanceUnit? unitForInstallment(int installmentId) {
    for (final unit in units) {
      if (unit.installments.any((i) => i.id == installmentId)) return unit;
    }
    return null;
  }

  FinanceUnit? unitById(int unitId) {
    for (final unit in units) {
      if (unit.unitId == unitId) return unit;
    }
    return null;
  }
}

/// Portfolio totals across all of the customer's units. Money totals only
/// cover units that have a payment plan.
class FinancialSummary {
  final int totalUnits;
  final int unitsWithPlan;
  final int unitsAwaitingPlan;
  final double totalContractValue;
  final double totalPaid;
  final double remainingBalance;
  final double overallPaidPercentage;
  final double totalOverdueAmount;
  final int unitsWithOverdue;

  const FinancialSummary({
    this.totalUnits = 0,
    this.unitsWithPlan = 0,
    this.unitsAwaitingPlan = 0,
    this.totalContractValue = 0,
    this.totalPaid = 0,
    this.remainingBalance = 0,
    this.overallPaidPercentage = 0,
    this.totalOverdueAmount = 0,
    this.unitsWithOverdue = 0,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      FinancialSummary(
        totalUnits: parseIntOrNull(json['total_units']) ?? 0,
        unitsWithPlan: parseIntOrNull(json['units_with_plan']) ?? 0,
        unitsAwaitingPlan: parseIntOrNull(json['units_awaiting_plan']) ?? 0,
        totalContractValue: parseMoney(json['total_contract_value']),
        totalPaid: parseMoney(json['total_paid']),
        remainingBalance: parseMoney(json['remaining_balance']),
        overallPaidPercentage: parseMoney(json['overall_paid_percentage']),
        totalOverdueAmount: parseMoney(json['total_overdue_amount']),
        unitsWithOverdue: parseIntOrNull(json['units_with_overdue']) ?? 0,
      );
}

class FinanceUnit {
  final int? unitId;

  /// Can be null; display [label].
  final String? unitName;

  /// From the client's sheets, e.g. `B1-G-01`. Unique within a project.
  final String? unitCode;
  final String? unitLabel;
  final Building? building;
  final FinanceProject? project;
  final UnitFinancials? financials;
  final List<Installment> installments;

  /// `main_image` / `media`, when the finance payload carries them.
  final String? imageUrl;
  final List<String> gallery;

  const FinanceUnit({
    this.unitId,
    this.unitName,
    this.unitCode,
    this.unitLabel,
    this.building,
    this.project,
    this.financials,
    this.installments = const [],
    this.imageUrl,
    this.gallery = const [],
  });

  factory FinanceUnit.fromJson(Map<String, dynamic> json) {
    final project = _asMap(json['project']);
    final financials = _asMap(json['financials']);
    final building = _asMap(json['building']);
    return FinanceUnit(
      unitId: parseIntOrNull(json['unit_id'] ?? json['id']),
      unitName: (json['unit_name'] ?? json['name'])?.toString(),
      unitCode: (json['unit_code'] ?? json['code'])?.toString(),
      unitLabel: (json['unit_label'] ?? json['label'])?.toString(),
      building: building == null ? null : Building.fromJson(building),
      project: project == null ? null : FinanceProject.fromJson(project),
      financials: financials == null
          ? null
          : UnitFinancials.fromJson(financials),
      installments: _asMapList(
        json['installments'],
      ).map(Installment.fromJson).toList(),
      imageUrl: mediaUrl(json['main_image'] ?? json['unit_image']),
      gallery: mediaUrls(json['media']),
    );
  }

  bool get hasPaymentPlan => financials?.hasPaymentPlan ?? false;

  /// Main image first, then the gallery: what the full-screen viewer pages
  /// through.
  List<String> get images => [if (imageUrl != null) imageUrl!, ...gallery];

  /// "Town 1 · T-1-G": the API's label, falling back to name then code.
  String get label => unitLabel ?? unitName ?? unitCode ?? '';
}

class FinanceProject {
  final int? id;
  final String? name;

  const FinanceProject({this.id, this.name});

  factory FinanceProject.fromJson(Map<String, dynamic> json) => FinanceProject(
    id: parseIntOrNull(json['id']),
    name: json['name']?.toString(),
  );
}

/// One part of the contract (unit, maintenance deposit, club house).
class ComponentBreakdown {
  final double total;
  final double scheduled;
  final double paid;
  final double remaining;

  const ComponentBreakdown({
    this.total = 0,
    this.scheduled = 0,
    this.paid = 0,
    this.remaining = 0,
  });

  factory ComponentBreakdown.fromJson(Map<String, dynamic> json) =>
      ComponentBreakdown(
        total: parseMoney(json['total']),
        scheduled: parseMoney(json['scheduled']),
        paid: parseMoney(json['paid']),
        remaining: parseMoney(json['remaining']),
      );

  double get paidFraction =>
      total <= 0 ? 0 : (paid / total).clamp(0, 1).toDouble();
}

/// Every row counts in exactly one bucket:
/// `paid + partiallyPaid + pending + overdue == total`.
class InstallmentCounts {
  final int total;
  final int paid;
  final int partiallyPaid;
  final int pending;
  final int overdue;

  const InstallmentCounts({
    this.total = 0,
    this.paid = 0,
    this.partiallyPaid = 0,
    this.pending = 0,
    this.overdue = 0,
  });

  factory InstallmentCounts.fromJson(Map<String, dynamic> json) =>
      InstallmentCounts(
        total: parseIntOrNull(json['total']) ?? 0,
        paid: parseIntOrNull(json['paid']) ?? 0,
        partiallyPaid: parseIntOrNull(json['partially_paid']) ?? 0,
        pending: parseIntOrNull(json['pending']) ?? 0,
        overdue: parseIntOrNull(json['overdue']) ?? 0,
      );
}

/// `financials` on the finance endpoints (`UnitFinancials` in Swagger).
class UnitFinancials {
  final double unitValue;
  final double maintenanceDepositAmount;
  final double clubHouseAmount;
  final double contractTotal;
  final bool hasPaymentPlan;
  final double totalPaid;
  final double remainingBalance;
  final double overdueAmount;
  final double paidPercentage;
  final ComponentBreakdown? unitComponent;
  final ComponentBreakdown? maintenanceDepositComponent;
  final ComponentBreakdown? clubHouseComponent;
  final InstallmentCounts installmentCounts;
  final Installment? nextInstallment;

  const UnitFinancials({
    this.unitValue = 0,
    this.maintenanceDepositAmount = 0,
    this.clubHouseAmount = 0,
    this.contractTotal = 0,
    this.hasPaymentPlan = false,
    this.totalPaid = 0,
    this.remainingBalance = 0,
    this.overdueAmount = 0,
    this.paidPercentage = 0,
    this.unitComponent,
    this.maintenanceDepositComponent,
    this.clubHouseComponent,
    this.installmentCounts = const InstallmentCounts(),
    this.nextInstallment,
  });

  factory UnitFinancials.fromJson(Map<String, dynamic> json) {
    final components = _asMap(json['components']) ?? const {};
    ComponentBreakdown? component(String key) {
      final map = _asMap(components[key]);
      return map == null ? null : ComponentBreakdown.fromJson(map);
    }

    final counts = _asMap(json['installment_counts']);
    final next = _asMap(json['next_installment']);
    return UnitFinancials(
      unitValue: parseMoney(json['unit_value']),
      maintenanceDepositAmount: parseMoney(json['maintenance_deposit_amount']),
      clubHouseAmount: parseMoney(json['club_house_amount']),
      contractTotal: parseMoney(json['contract_total']),
      hasPaymentPlan: json['has_payment_plan'] == true,
      totalPaid: parseMoney(json['total_paid']),
      remainingBalance: parseMoney(json['remaining_balance']),
      overdueAmount: parseMoney(json['overdue_amount']),
      paidPercentage: parseMoney(json['paid_percentage']),
      unitComponent: component('unit'),
      maintenanceDepositComponent: component('maintenance_deposit'),
      clubHouseComponent: component('club_house'),
      installmentCounts: counts == null
          ? const InstallmentCounts()
          : InstallmentCounts.fromJson(counts),
      nextInstallment: next == null ? null : Installment.fromJson(next),
    );
  }

  /// Contract parts to display, in order, skipping parts whose total is 0.
  List<(InstallmentType, ComponentBreakdown)> get visibleComponents => [
    if (unitComponent != null && unitComponent!.total > 0)
      (InstallmentType.installment, unitComponent!),
    if (maintenanceDepositComponent != null &&
        maintenanceDepositComponent!.total > 0)
      (InstallmentType.maintenanceDeposit, maintenanceDepositComponent!),
    if (clubHouseComponent != null && clubHouseComponent!.total > 0)
      (InstallmentType.clubHouse, clubHouseComponent!),
  ];
}

class InstallmentPayment {
  final int? id;
  final double amount;
  final DateTime? paidAt;
  final PaymentMethod method;
  final String? receiptNo;

  const InstallmentPayment({
    this.id,
    this.amount = 0,
    this.paidAt,
    this.method = PaymentMethod.unknown,
    this.receiptNo,
  });

  factory InstallmentPayment.fromJson(Map<String, dynamic> json) =>
      InstallmentPayment(
        id: parseIntOrNull(json['id']),
        amount: parseMoney(json['amount']),
        paidAt: parseApiDate(json['paid_at']),
        method: PaymentMethod.parse(json['method']),
        receiptNo: json['receipt_no']?.toString(),
      );
}

/// Unit reference carried by upcoming-installment rows (a `UnitSummary`).
typedef InstallmentUnitRef = UnitSummary;

/// One row of a payment plan (`Installment` in Swagger). Also used for
/// `next_installment`, which carries a subset of these fields.
class Installment {
  final int? id;
  final int? number;
  final InstallmentType type;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final InstallmentStatus status;
  final bool isOverdue;

  /// Negative when overdue, 0 when due today, null when paid.
  final int? daysUntilDue;
  final List<InstallmentPayment> payments;
  final InstallmentUnitRef? unit;

  const Installment({
    this.id,
    this.number,
    this.type = InstallmentType.unknown,
    this.amount = 0,
    this.paidAmount = 0,
    this.remainingAmount = 0,
    this.dueDate,
    this.paidAt,
    this.status = InstallmentStatus.unknown,
    this.isOverdue = false,
    this.daysUntilDue,
    this.payments = const [],
    this.unit,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    final unit = _asMap(json['unit']);
    return Installment(
      id: parseIntOrNull(json['id']),
      number: parseIntOrNull(json['number']),
      type: InstallmentType.parse(json['type']),
      amount: parseMoney(json['amount']),
      paidAmount: parseMoney(json['paid_amount']),
      remainingAmount: parseMoney(json['remaining_amount']),
      dueDate: parseApiDate(json['due_date']),
      paidAt: parseApiDate(json['paid_at']),
      status: InstallmentStatus.parse(json['status']),
      isOverdue: json['is_overdue'] == true,
      daysUntilDue: parseIntOrNull(json['days_until_due']),
      payments: _asMapList(
        json['payments'],
      ).map(InstallmentPayment.fromJson).toList(),
      unit: unit == null ? null : UnitSummary.fromJson(unit),
    );
  }

  /// `status` is refreshed by a nightly job, while `is_overdue` is always
  /// current, so it wins.
  InstallmentStatus get displayStatus =>
      isOverdue ? InstallmentStatus.overdue : status;

  double get paidFraction =>
      amount <= 0 ? 0 : (paidAmount / amount).clamp(0, 1).toDouble();
}
