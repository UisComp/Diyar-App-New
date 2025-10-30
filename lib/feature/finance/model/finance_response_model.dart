import 'package:json_annotation/json_annotation.dart';
part 'finance_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FinanceResponseModel {
  final bool? success;
  final String? message;
  final FinancialData? data;

  FinanceResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory FinanceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FinanceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FinanceResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FinancialData {
  @JsonKey(name: 'financial_summary')
  final FinancialSummary? financialSummary;

  final List<Unit>? units;

  FinancialData({
    this.financialSummary,
    this.units,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) =>
      _$FinancialDataFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialDataToJson(this);
}

@JsonSerializable()
class FinancialSummary {
  @JsonKey(name: 'total_units')
  final int? totalUnits;

  @JsonKey(name: 'total_unit_value')
  final int? totalUnitValue;

  @JsonKey(name: 'total_down_payment')
  final double? totalDownPayment;

  @JsonKey(name: 'total_after_interest')
  final double? totalAfterInterest;

  @JsonKey(name: 'total_paid')
  final double? totalPaid;

  @JsonKey(name: 'remaining_balance')
  final double? remainingBalance;

  @JsonKey(name: 'overall_paid_percentage')
  final double? overallPaidPercentage;

  @JsonKey(name: 'total_overdue_amount')
  final double? totalOverdueAmount;

  @JsonKey(name: 'units_with_overdue')
  final int? unitsWithOverdue;

  FinancialSummary({
    this.totalUnits,
    this.totalUnitValue,
    this.totalDownPayment,
    this.totalAfterInterest,
    this.totalPaid,
    this.remainingBalance,
    this.overallPaidPercentage,
    this.totalOverdueAmount,
    this.unitsWithOverdue,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialSummaryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Unit {
  @JsonKey(name: 'unit_id')
  final int? unitId;

  @JsonKey(name: 'unit_name')
  final String? unitName;

  @JsonKey(name: 'unit_number')
  final String? unitNumber;

  final Project? project;
  final Financials? financials;
  final List<Installment>? installments;

  Unit({
    this.unitId,
    this.unitName,
    this.unitNumber,
    this.project,
    this.financials,
    this.installments,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

@JsonSerializable()
class Project {
  final int? id;
  final String? name;

  Project({this.id, this.name});

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Financials {
  @JsonKey(name: 'unit_value')
  final String? unitValue;

  @JsonKey(name: 'down_payment')
  final String? downPayment;

  final double? principal;

  @JsonKey(name: 'interest_rate')
  final String? interestRate;

  @JsonKey(name: 'total_interest')
  final double? totalInterest;

  @JsonKey(name: 'total_after_interest')
  final double? totalAfterInterest;

  @JsonKey(name: 'installments_count')
  final int? installmentsCount;

  @JsonKey(name: 'installment_amount')
  final double? installmentAmount;

  @JsonKey(name: 'total_paid')
  final dynamic  totalPaid;

  @JsonKey(name: 'remaining_balance')
  final double?  remainingBalance;

  @JsonKey(name: 'paid_percentage')
  final double?  paidPercentage;

  @JsonKey(name: 'payment_statistics')
  final PaymentStatistics? paymentStatistics;

  @JsonKey(name: 'next_installment')
  final NextInstallment? nextInstallment;

  @JsonKey(name: 'overdue_amount')
  final dynamic overdueAmount;

  Financials({
    this.unitValue,
    this.downPayment,
    this.principal,
    this.interestRate,
    this.totalInterest,
    this.totalAfterInterest,
    this.installmentsCount,
    this.installmentAmount,
    this.totalPaid,
    this.remainingBalance,
    this.paidPercentage,
    this.paymentStatistics,
    this.nextInstallment,
    this.overdueAmount,
  });

  factory Financials.fromJson(Map<String, dynamic> json) =>
      _$FinancialsFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialsToJson(this);
}

@JsonSerializable()
class PaymentStatistics {
  @JsonKey(name: 'total_installments')
  final int?  totalInstallments;

  @JsonKey(name: 'paid_installments')
  final int?  paidInstallments;

  @JsonKey(name: 'pending_installments')
  final int?  pendingInstallments;

  @JsonKey(name: 'overdue_installments')
  final int?  overdueInstallments;

  @JsonKey(name: 'on_time_percentage')
  final int? onTimePercentage;

  PaymentStatistics({
    this.totalInstallments,
    this.paidInstallments,
    this.pendingInstallments,
    this.overdueInstallments,
    this.onTimePercentage,
  });

  factory PaymentStatistics.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatisticsToJson(this);
}

@JsonSerializable()
class NextInstallment {
  final int?  id;
  final String?  number;
  final String?  amount;
  @JsonKey(name: 'due_date')
  final String?  dueDate;
  @JsonKey(name: 'days_until_due')
  final double?  daysUntilDue;

  NextInstallment({
    this.id,
    this.number,
    this.amount,
    this.dueDate,
    this.daysUntilDue,
  });

  factory NextInstallment.fromJson(Map<String, dynamic> json) =>
      _$NextInstallmentFromJson(json);

  Map<String, dynamic> toJson() => _$NextInstallmentToJson(this);
}

@JsonSerializable()
class Installment {
  final int?  id;
  final String?  number;
  final double?  amount;

  @JsonKey(name: 'due_date')
  final String?  dueDate;

  final String?  status;

  Installment({
    this.id,
    this.number,
    this.amount,
    this.dueDate,
    this.status,
  });

  factory Installment.fromJson(Map<String, dynamic> json) =>
      _$InstallmentFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentToJson(this);
}
