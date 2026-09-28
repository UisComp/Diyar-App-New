import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';

/// Where tapping a notification should take the user.
sealed class NotificationTarget {
  const NotificationTarget();
}

/// The finance tab (payments overview).
class FinanceTabTarget extends NotificationTarget {
  const FinanceTabTarget();
}

/// The payment plan of the unit that contains [installmentId].
class UnitPaymentPlanTarget extends NotificationTarget {
  const UnitPaymentPlanTarget(this.installmentId);
  final int installmentId;

  @override
  bool operator ==(Object other) =>
      other is UnitPaymentPlanTarget && other.installmentId == installmentId;

  @override
  int get hashCode => installmentId.hashCode;
}

class NotificationsListTarget extends NotificationTarget {
  const NotificationsListTarget();
}

/// Staff reviewed one of the resident's phone number requests.
class PhoneNumbersTarget extends NotificationTarget {
  const PhoneNumbersTarget();
}

abstract class NotificationRouting {
  static const String paymentType = 'payment';
  static const String overdueType = 'overdue';
  static const String installmentDueType = 'installment_due';
  static const String paymentPlanType = 'payment_plan';
  static const String lateTaxType = 'late_tax';
  static const String phoneRequestType = 'phone_request';

  /// Types whose `entity_id` is an installment, so a tap can deep-link
  /// straight to that installment's payment plan.
  static const Set<String> _installmentTypes = {
    paymentType,
    overdueType,
    installmentDueType,
  };

  /// Financial types whose entity is not an installment (a plan, a tax
  /// record); a tap lands on the payments overview instead.
  static const Set<String> _financeOverviewTypes = {
    paymentPlanType,
    lateTaxType,
  };

  static bool _isInstallmentLinked({String? type, String? entityType}) =>
      _installmentTypes.contains(type) ||
      entityType == NotificationEntityType.payment ||
      entityType == NotificationEntityType.overdue ||
      entityType == NotificationEntityType.installmentDue;

  /// Notifications that concern the customer's finances, so the finance
  /// screens refresh when one arrives.
  static bool isFinancial({String? type, String? entityType}) =>
      _isInstallmentLinked(type: type, entityType: entityType) ||
      _financeOverviewTypes.contains(type);

  /// Target for a financial notification, or null if it isn't one.
  /// - `payment` (entity 4) → the plan of the installment it was applied to.
  /// - manual `overdue` reminder (entity 3 + id) → that installment's plan.
  /// - `installment_due` reminder (entity 5) → that installment's plan.
  /// - nightly `overdue` summary (no id) → the payments overview.
  /// - `payment_plan` / `late_tax` → the payments overview; their entity_id
  ///   is not an installment, so it must not be parsed as one.
  static NotificationTarget? financialTarget({
    String? type,
    String? entityType,
    String? entityId,
  }) {
    if (!isFinancial(type: type, entityType: entityType)) return null;
    final installmentId = _isInstallmentLinked(type: type, entityType: entityType)
        ? int.tryParse(entityId ?? '')
        : null;
    return installmentId == null
        ? const FinanceTabTarget()
        : UnitPaymentPlanTarget(installmentId);
  }

  /// Target for a push notification's FCM `data` payload.
  static NotificationTarget pushTarget(Map<String, dynamic> data) {
    if (data['type']?.toString() == phoneRequestType) {
      return const PhoneNumbersTarget();
    }
    return financialTarget(
          type: data['type']?.toString(),
          entityType: data['entity_type']?.toString(),
          entityId: data['entity_id']?.toString(),
        ) ??
        const NotificationsListTarget();
  }
}
