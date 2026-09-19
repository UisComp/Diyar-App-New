import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/feature/notifications/helper/notification_routing.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_numbers_controller.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_numbers_state.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_request_controller.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_request_state.dart';
import 'package:diyar_app/feature/phone_numbers/model/phone_numbers_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

/// `GET /api/profile/phones` as in §7.1.
Map<String, dynamic> phonesJson({
  List<Map<String, dynamic>>? requests,
  int max = 3,
}) => {
  'phones': [
    {'id': 5, 'phone': '+201112345678', 'is_primary': false, 'verified': false},
    {'id': 3, 'phone': '+201012345678', 'is_primary': true, 'verified': true},
  ],
  'requests':
      requests ??
      [
        {
          'id': 7,
          'type': 'add',
          'status': 'pending',
          'old_phone': null,
          'new_phone': '+201512345678',
          'rejection_reason': null,
          'created_at': '2026-09-19T10:00:00.000000Z',
          'reviewed_at': null,
        },
      ],
  'max_pending_requests': max,
};

Map<String, dynamic> requestJson({
  int id = 8,
  String type = 'add',
  String status = 'pending',
}) => {
  'id': id,
  'type': type,
  'status': status,
  'old_phone': null,
  'new_phone': '+201512345678',
  'rejection_reason': null,
  'created_at': '2026-09-19T10:00:00.000000Z',
  'reviewed_at': null,
};

void main() {
  late FakeApi api;
  setUp(() async {
    api = await setUpAuthTestEnv();
    await signIn(token: '13|me');
  });

  group('models', () {
    test('overview: primary first, pending count, limits', () {
      final o = PhoneNumbersOverview.fromJson(phonesJson());
      expect(o.phones.first.id, 3);
      expect(o.phones.first.isPrimary, isTrue);
      expect(o.pendingCount, 1);
      expect(o.canRequestMore, isTrue);
      expect(o.canRemove, isTrue);
      expect(o.hasPendingRequestFor('+201512345678'), isTrue);
      expect(o.hasPendingRequestFor('+201012345678'), isFalse);
    });

    test('limit reached and a single number', () {
      final o = PhoneNumbersOverview.fromJson(
        phonesJson(max: 1, requests: [requestJson()])
          ..['phones'] = [
            {'id': 3, 'phone': '+201012345678', 'is_primary': true},
          ],
      );
      expect(o.canRequestMore, isFalse);
      expect(o.canRemove, isFalse);
    });

    test('a request with an unknown status is skipped, not a crash', () {
      final o = PhoneNumbersOverview.fromJson(
        phonesJson(
          requests: [
            requestJson(status: 'something-new'),
            requestJson(id: 9, status: 'rejected'),
          ],
        ),
      );
      expect(o.requests.single.id, 9);
      expect(o.requests.single.status, PhoneChangeStatus.rejected);
    });

    test('request fields', () {
      final r = PhoneChangeRequest.fromJson({
        ...requestJson(type: 'replace', status: 'rejected'),
        'old_phone': '+201112345678',
        'rejection_reason': 'Not the owner',
        'reviewed_at': '2026-09-20T08:00:00.000000Z',
      });
      expect(r.type, PhoneChangeType.replace);
      expect(r.oldPhone, '+201112345678');
      expect(r.rejectionReason, 'Not the owner');
      expect(r.reviewedAt, DateTime.utc(2026, 9, 20, 8));
      expect(r.isPending, isFalse);
    });
  });

  group('PhoneNumbersController (§7.1, §7.3–7.5)', () {
    test('load', () async {
      api.on('GET', 'profile/phones', body: apiOk(phonesJson()));
      final c = PhoneNumbersController();
      addTearDown(c.close);
      expect(c.isFirstLoad, isTrue);

      await c.load();

      expect(c.state, isA<PhoneNumbersLoadedState>());
      expect(c.isFirstLoad, isFalse);
      expect(c.overview.phones, hasLength(2));
      expect(api.last('GET', 'profile/phones').authorization, 'Bearer 13|me');
    });

    test('load failure', () async {
      api.offline('GET', 'profile/phones');
      final c = PhoneNumbersController();
      addTearDown(c.close);
      await c.load();
      expect(
        (c.state as PhoneNumbersLoadFailureState).result.isNetworkError,
        isTrue,
      );
    });

    test('make primary: immediate, uses the returned list', () async {
      final swapped = phonesJson();
      (swapped['phones'] as List)[0]['is_primary'] = true;
      (swapped['phones'] as List)[1]['is_primary'] = false;
      api.on('PATCH', 'profile/phones/5/primary', body: apiOk(swapped));
      final c = PhoneNumbersController();
      addTearDown(c.close);

      await c.makePrimary(5);

      expect(c.state, isA<PhoneNumbersActionSuccessState>());
      expect(c.overview.phones.first.id, 5);
      expect(api.sent('GET', 'profile/phones'), isEmpty);
    });

    test('remove: a request without a code, then reload', () async {
      api.on(
        'POST',
        'profile/phone-requests',
        status: 201,
        body: apiOk(requestJson(type: 'remove')),
      );
      api.on('GET', 'profile/phones', body: apiOk(phonesJson()));
      final c = PhoneNumbersController();
      addTearDown(c.close);
      final states = <PhoneNumbersState>[];
      final sub = c.stream.listen(states.add);
      addTearDown(sub.cancel);

      await c.requestRemoval(5);

      expect(api.last('POST', 'profile/phone-requests').json, {
        'type': 'remove',
        'phone_id': 5,
      });
      expect(
        states.whereType<PhoneNumbersActionSuccessState>().single.action,
        PhoneNumbersAction.removalRequested,
      );
      expect(c.state, isA<PhoneNumbersLoadedState>());
    });

    for (final code in [
      ApiErrorCodes.lastNumber,
      ApiErrorCodes.tooManyPending,
      ApiErrorCodes.targetPending,
      ApiErrorCodes.notYourNumber,
    ]) {
      test('remove fails with $code', () async {
        api.on(
          'POST',
          'profile/phone-requests',
          status: 422,
          body: apiError(code),
        );
        final c = PhoneNumbersController();
        addTearDown(c.close);

        await c.requestRemoval(3);

        expect(
          (c.state as PhoneNumbersActionFailureState).result.errorCode,
          code,
        );
      });
    }

    test('cancel a pending request', () async {
      api.on(
        'DELETE',
        'profile/phone-requests/7',
        body: apiOk(requestJson(id: 7, status: 'cancelled')),
      );
      api.on('GET', 'profile/phones', body: apiOk(phonesJson(requests: [])));
      final c = PhoneNumbersController();
      addTearDown(c.close);

      await c.cancelRequest(7);

      expect(api.sent('DELETE', 'profile/phone-requests/7'), hasLength(1));
      expect(c.overview.requests, isEmpty);
    });

    test('cancel an already reviewed request', () async {
      api.on(
        'DELETE',
        'profile/phone-requests/7',
        status: 422,
        body: apiError(ApiErrorCodes.notPending),
      );
      final c = PhoneNumbersController();
      addTearDown(c.close);
      await c.cancelRequest(7);
      expect(
        (c.state as PhoneNumbersActionFailureState).result.errorCode,
        ApiErrorCodes.notPending,
      );
    });
  });

  group('PhoneRequestController (§7.2)', () {
    PhoneRequestController make({int? replacing}) {
      final c = PhoneRequestController(replacedPhoneId: replacing);
      addTearDown(c.close);
      c.phoneController.value = const PhoneNumber(
        isoCode: IsoCode.EG,
        nsn: '1512345678',
      );
      return c;
    }

    test('add: code to the new number, then the request', () async {
      api.on('POST', 'profile/phones/otp', body: apiOk({'resend_in': 60}));
      api.on(
        'POST',
        'profile/phone-requests',
        status: 201,
        body: apiOk(requestJson()),
      );
      final c = make();
      expect(c.type, PhoneChangeType.add);

      await c.sendCode();
      expect(c.state, isA<PhoneRequestCodeSentState>());
      expect(c.codeSentTo, '+201512345678');
      expect(api.last('POST', 'profile/phones/otp').json, {
        'phone': '+201512345678',
      });

      c.codeController.text = '123456';
      await c.submit();

      expect(c.state, isA<PhoneRequestSubmittedState>());
      expect(api.last('POST', 'profile/phone-requests').json, {
        'type': 'add',
        'phone': '+201512345678',
        'code': '123456',
      });
    });

    test('replace sends the replaced phone_id', () async {
      api.on('POST', 'profile/phones/otp', body: apiOk({'resend_in': 60}));
      api.on(
        'POST',
        'profile/phone-requests',
        status: 201,
        body: apiOk(requestJson(type: 'replace')),
      );
      final c = make(replacing: 5);
      await c.sendCode();
      c.codeController.text = '123456';
      await c.submit();

      expect(api.last('POST', 'profile/phone-requests').json, {
        'type': 'replace',
        'phone': '+201512345678',
        'phone_id': 5,
        'code': '123456',
      });
    });

    test('number_taken when asking for the code', () async {
      api.on(
        'POST',
        'profile/phones/otp',
        status: 409,
        body: apiError(ApiErrorCodes.numberTaken),
      );
      final c = make();
      await c.sendCode();
      expect(
        (c.state as PhoneRequestFailureState).result.errorCode,
        ApiErrorCodes.numberTaken,
      );
      expect(c.codeSentTo, isNull);
    });

    test('a wrong code clears the field; burned unlocks resend', () async {
      api.on('POST', 'profile/phones/otp', body: apiOk({'resend_in': 60}));
      api.on(
        'POST',
        'profile/phone-requests',
        status: 422,
        body: apiError(ApiErrorCodes.invalid),
      );
      api.on(
        'POST',
        'profile/phone-requests',
        status: 422,
        body: apiError(ApiErrorCodes.burned),
      );
      final c = make();
      await c.sendCode();

      c.codeController.text = '000000';
      await c.submit();
      expect(c.codeController.text, isEmpty);
      expect(c.resendIn, greaterThan(0));

      c.codeController.text = '000001';
      await c.submit();
      expect(c.resendIn, 0);
    });

    test('changing the number starts over', () async {
      api.on('POST', 'profile/phones/otp', body: apiOk({'resend_in': 60}));
      final c = make();
      await c.sendCode();
      c.changeNumber();
      expect(c.codeSentTo, isNull);
      expect(c.resendIn, 0);
      expect(c.state, isA<PhoneRequestInitialState>());
    });

    test('no request without a sent code', () async {
      final c = make();
      c.codeController.text = '123456';
      await c.submit();
      expect(api.requests, isEmpty);
    });
  });

  test('a phone_request push opens the phone numbers screen', () {
    expect(
      NotificationRouting.pushTarget({'type': 'phone_request'}),
      isA<PhoneNumbersTarget>(),
    );
  });
}
