// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinanceResponseModel _$FinanceResponseModelFromJson(
        Map<String, dynamic> json) =>
    FinanceResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : FinancialData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FinanceResponseModelToJson(
        FinanceResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

FinancialData _$FinancialDataFromJson(Map<String, dynamic> json) =>
    FinancialData(
      financialSummary: json['financial_summary'] == null
          ? null
          : FinancialSummary.fromJson(
              json['financial_summary'] as Map<String, dynamic>),
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinancialDataToJson(FinancialData instance) =>
    <String, dynamic>{
      'financial_summary': instance.financialSummary?.toJson(),
      'units': instance.units?.map((e) => e.toJson()).toList(),
    };

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    FinancialSummary(
      totalUnits: (json['total_units'] as num?)?.toInt(),
      totalUnitValue: (json['total_unit_value'] as num?)?.toInt(),
      totalDownPayment: (json['total_down_payment'] as num?)?.toDouble(),
      totalAfterInterest: (json['total_after_interest'] as num?)?.toDouble(),
      totalPaid: (json['total_paid'] as num?)?.toDouble(),
      remainingBalance: (json['remaining_balance'] as num?)?.toDouble(),
      overallPaidPercentage:
          (json['overall_paid_percentage'] as num?)?.toDouble(),
      totalOverdueAmount: (json['total_overdue_amount'] as num?)?.toDouble(),
      unitsWithOverdue: (json['units_with_overdue'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FinancialSummaryToJson(FinancialSummary instance) =>
    <String, dynamic>{
      'total_units': instance.totalUnits,
      'total_unit_value': instance.totalUnitValue,
      'total_down_payment': instance.totalDownPayment,
      'total_after_interest': instance.totalAfterInterest,
      'total_paid': instance.totalPaid,
      'remaining_balance': instance.remainingBalance,
      'overall_paid_percentage': instance.overallPaidPercentage,
      'total_overdue_amount': instance.totalOverdueAmount,
      'units_with_overdue': instance.unitsWithOverdue,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      unitId: (json['unit_id'] as num?)?.toInt(),
      unitName: json['unit_name'] as String?,
      unitNumber: json['unit_number'] as String?,
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      financials: json['financials'] == null
          ? null
          : Financials.fromJson(json['financials'] as Map<String, dynamic>),
      installments: (json['installments'] as List<dynamic>?)
          ?.map((e) => Installment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'unit_id': instance.unitId,
      'unit_name': instance.unitName,
      'unit_number': instance.unitNumber,
      'project': instance.project?.toJson(),
      'financials': instance.financials?.toJson(),
      'installments': instance.installments?.map((e) => e.toJson()).toList(),
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Financials _$FinancialsFromJson(Map<String, dynamic> json) => Financials(
      unitValue: json['unit_value'] as String?,
      downPayment: json['down_payment'] as String?,
      principal: (json['principal'] as num?)?.toDouble(),
      interestRate: json['interest_rate'] as String?,
      totalInterest: (json['total_interest'] as num?)?.toDouble(),
      totalAfterInterest: (json['total_after_interest'] as num?)?.toDouble(),
      installmentsCount: (json['installments_count'] as num?)?.toInt(),
      installmentAmount: (json['installment_amount'] as num?)?.toDouble(),
      totalPaid: json['total_paid'],
      remainingBalance: (json['remaining_balance'] as num?)?.toDouble(),
      paidPercentage: (json['paid_percentage'] as num?)?.toDouble(),
      paymentStatistics: json['payment_statistics'] == null
          ? null
          : PaymentStatistics.fromJson(
              json['payment_statistics'] as Map<String, dynamic>),
      nextInstallment: json['next_installment'] == null
          ? null
          : NextInstallment.fromJson(
              json['next_installment'] as Map<String, dynamic>),
      overdueAmount: json['overdue_amount'],
    );

Map<String, dynamic> _$FinancialsToJson(Financials instance) =>
    <String, dynamic>{
      'unit_value': instance.unitValue,
      'down_payment': instance.downPayment,
      'principal': instance.principal,
      'interest_rate': instance.interestRate,
      'total_interest': instance.totalInterest,
      'total_after_interest': instance.totalAfterInterest,
      'installments_count': instance.installmentsCount,
      'installment_amount': instance.installmentAmount,
      'total_paid': instance.totalPaid,
      'remaining_balance': instance.remainingBalance,
      'paid_percentage': instance.paidPercentage,
      'payment_statistics': instance.paymentStatistics?.toJson(),
      'next_installment': instance.nextInstallment?.toJson(),
      'overdue_amount': instance.overdueAmount,
    };

PaymentStatistics _$PaymentStatisticsFromJson(Map<String, dynamic> json) =>
    PaymentStatistics(
      totalInstallments: (json['total_installments'] as num?)?.toInt(),
      paidInstallments: (json['paid_installments'] as num?)?.toInt(),
      pendingInstallments: (json['pending_installments'] as num?)?.toInt(),
      overdueInstallments: (json['overdue_installments'] as num?)?.toInt(),
      onTimePercentage: (json['on_time_percentage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentStatisticsToJson(PaymentStatistics instance) =>
    <String, dynamic>{
      'total_installments': instance.totalInstallments,
      'paid_installments': instance.paidInstallments,
      'pending_installments': instance.pendingInstallments,
      'overdue_installments': instance.overdueInstallments,
      'on_time_percentage': instance.onTimePercentage,
    };

NextInstallment _$NextInstallmentFromJson(Map<String, dynamic> json) =>
    NextInstallment(
      id: (json['id'] as num?)?.toInt(),
      number: json['number'] as String?,
      amount: json['amount'] as String?,
      dueDate: json['due_date'] as String?,
      daysUntilDue: (json['days_until_due'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NextInstallmentToJson(NextInstallment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'amount': instance.amount,
      'due_date': instance.dueDate,
      'days_until_due': instance.daysUntilDue,
    };

Installment _$InstallmentFromJson(Map<String, dynamic> json) => Installment(
      id: (json['id'] as num?)?.toInt(),
      number: json['number'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      dueDate: json['due_date'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$InstallmentToJson(Installment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'amount': instance.amount,
      'due_date': instance.dueDate,
      'status': instance.status,
    };
