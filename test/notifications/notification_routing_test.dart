import 'package:diyar_app/feature/notifications/helper/notification_routing.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('push data routing', () {
    test('payment push opens the plan of the installment', () {
      final target = NotificationRouting.pushTarget({
        'type': 'payment',
        'entity_type': '4',
        'entity_id': '12',
        'title': 'Payment Received',
      });
      expect(target, const UnitPaymentPlanTarget(12));
    });

    test('nightly overdue summary (no entity_id) opens the finance tab', () {
      final target = NotificationRouting.pushTarget({
        'type': 'overdue',
        'entity_type': '3',
      });
      expect(target, isA<FinanceTabTarget>());
    });

    test('manual overdue reminder opens that installment plan', () {
      final target = NotificationRouting.pushTarget({
        'type': 'overdue',
        'entity_type': '3',
        'entity_id': '7',
      });
      expect(target, const UnitPaymentPlanTarget(7));
    });

    test('other pushes open the notifications list', () {
      expect(
        NotificationRouting.pushTarget({'type': 'all'}),
        isA<NotificationsListTarget>(),
      );
      expect(
        NotificationRouting.pushTarget({'type': 'personal'}),
        isA<NotificationsListTarget>(),
      );
      expect(
        NotificationRouting.pushTarget({
          'type': 'facility_booking',
          'entity_type': '1',
          'entity_id': '5',
        }),
        isA<NotificationsListTarget>(),
      );
    });

    test('a non-numeric id falls back to the finance tab', () {
      expect(
        NotificationRouting.pushTarget({'type': 'payment', 'entity_id': 'x'}),
        isA<FinanceTabTarget>(),
      );
    });
  });

  group('NotificationData (GET /api/notifications)', () {
    test('accepts entity_type / entity_id as numbers', () {
      final n = NotificationData.fromJson({
        'id': 1,
        'title': 'Payment Received',
        'description': 'We received your payment of 850,000.00 EGP.',
        'title_ar': 'تم استلام الدفعة',
        'description_ar': 'تم استلام دفعتك بقيمة 850,000.00 جنيه.',
        'type': 'payment',
        'entity_type': 4,
        'entity_id': 2,
      });
      expect(n.entityType, NotificationEntityType.payment);
      expect(n.entityId, '2');
      expect(
        NotificationRouting.financialTarget(
          type: n.type,
          entityType: n.entityType,
          entityId: n.entityId,
        ),
        const UnitPaymentPlanTarget(2),
      );
    });

    test('still accepts entity_type as a string and null', () {
      final a = NotificationData.fromJson({'entity_type': '1'});
      final b = NotificationData.fromJson({'entity_type': null});
      expect(a.entityType, NotificationEntityType.facilityBooking);
      expect(b.entityType, isNull);
      expect(
        NotificationRouting.financialTarget(entityType: a.entityType),
        isNull,
      );
    });
  });
}
