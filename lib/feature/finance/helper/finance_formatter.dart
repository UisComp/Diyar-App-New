import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FinanceFormatter {
  static final NumberFormat _money = NumberFormat('#,##0.00', 'en_US');

  /// `3000000` -> `3,000,000.00`. Western digits in both languages, matching
  /// the admin panel and the notification texts.
  static String amount(num value) => _money.format(value);

  /// `3000000` -> `3,000,000.00 EGP` / `3,000,000.00 ج.م`.
  static String money(num value) => '${amount(value)} ${LocaleKeys.egp.tr()}';

  static String percentage(num value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.endsWith('.00') ? fixed.substring(0, fixed.length - 3) : fixed;
  }

  /// `1 Oct 2026` / `1 أكتوبر 2026`.
  static String date(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    try {
      return DateFormat('d MMM yyyy', context.locale.languageCode).format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy').format(date);
    }
  }

  /// The "when" line of a row: "Paid on …", "Due today", "Due in 13 days",
  /// "3 days overdue". Relies on the server's `days_until_due` / `is_overdue`
  /// instead of the device clock.
  static String dueLabel(BuildContext context, Installment installment) {
    final days = installment.daysUntilDue;
    switch (installment.displayStatus) {
      case InstallmentStatus.paid:
        return installment.paidAt == null
            ? LocaleKeys.status_paid.tr()
            : LocaleKeys.paid_on.tr(args: [date(context, installment.paidAt)]);
      case InstallmentStatus.overdue:
        final overdueDays = (days ?? 0).abs();
        return overdueDays == 0
            ? LocaleKeys.status_overdue.tr()
            : LocaleKeys.days_overdue.plural(overdueDays);
      case InstallmentStatus.pending:
      case InstallmentStatus.partiallyPaid:
      case InstallmentStatus.unknown:
        if (days == null) return date(context, installment.dueDate);
        if (days <= 0) return LocaleKeys.due_today.tr();
        return LocaleKeys.due_in_days.plural(days);
    }
  }
}
