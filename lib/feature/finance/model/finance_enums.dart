import 'package:diyar_app/generated/locale_keys.g.dart';

/// What a row in a payment plan pays for.
enum InstallmentType {
  downPayment,
  installment,
  maintenanceDeposit,
  clubHouse,
  unknown;

  static InstallmentType parse(dynamic value) => switch (value) {
    'down_payment' => InstallmentType.downPayment,
    'installment' => InstallmentType.installment,
    'maintenance_deposit' => InstallmentType.maintenanceDeposit,
    'club_house' => InstallmentType.clubHouse,
    _ => InstallmentType.unknown,
  };

  String get labelKey => switch (this) {
    InstallmentType.downPayment => LocaleKeys.type_down_payment,
    InstallmentType.installment => LocaleKeys.type_installment,
    InstallmentType.maintenanceDeposit => LocaleKeys.type_maintenance_deposit,
    InstallmentType.clubHouse => LocaleKeys.type_club_house,
    InstallmentType.unknown => LocaleKeys.unknown,
  };
}

enum InstallmentStatus {
  pending,
  partiallyPaid,
  paid,
  overdue,
  unknown;

  static InstallmentStatus parse(dynamic value) => switch (value) {
    'pending' => InstallmentStatus.pending,
    'partially_paid' => InstallmentStatus.partiallyPaid,
    'paid' => InstallmentStatus.paid,
    'overdue' => InstallmentStatus.overdue,
    _ => InstallmentStatus.unknown,
  };

  String get labelKey => switch (this) {
    InstallmentStatus.pending => LocaleKeys.status_pending,
    InstallmentStatus.partiallyPaid => LocaleKeys.status_partially_paid,
    InstallmentStatus.paid => LocaleKeys.status_paid,
    InstallmentStatus.overdue => LocaleKeys.status_overdue,
    InstallmentStatus.unknown => LocaleKeys.unknown,
  };
}

enum PaymentMethod {
  cash,
  bankTransfer,
  cheque,
  card,
  other,
  unknown;

  static PaymentMethod parse(dynamic value) => switch (value) {
    'cash' => PaymentMethod.cash,
    'bank_transfer' => PaymentMethod.bankTransfer,
    'cheque' => PaymentMethod.cheque,
    'card' => PaymentMethod.card,
    'other' => PaymentMethod.other,
    _ => PaymentMethod.unknown,
  };

  String get labelKey => switch (this) {
    PaymentMethod.cash => LocaleKeys.method_cash,
    PaymentMethod.bankTransfer => LocaleKeys.method_bank_transfer,
    PaymentMethod.cheque => LocaleKeys.method_cheque,
    PaymentMethod.card => LocaleKeys.method_card,
    PaymentMethod.other => LocaleKeys.method_other,
    PaymentMethod.unknown => LocaleKeys.unknown,
  };
}
