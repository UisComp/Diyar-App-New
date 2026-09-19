import 'dart:async';

import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/helper/sms_code_retriever.dart';
import 'package:diyar_app/feature/auth/controller/otp_controller.dart';
import 'package:diyar_app/feature/auth/controller/otp_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

void main() {
  late FakeApi api;
  setUp(() async => api = await setUpAuthTestEnv());

  OtpController make(OtpPurpose purpose, {String locale = 'en'}) {
    final c = OtpController(
      args: OtpArgs(phone: '+201012345678', purpose: purpose),
      locale: locale,
    );
    addTearDown(c.close);
    return c;
  }

  group('sending the code (§4.3, §5.1)', () {
    test('login and reset use auth/otp; countdown from resend_in', () async {
      api.on(
        'POST',
        'auth/otp',
        body: apiOk({'expires_in': 300, 'resend_in': 60}),
      );
      for (final purpose in [OtpPurpose.login, OtpPurpose.resetPassword]) {
        final c = make(purpose);
        await c.sendCode();
        expect(c.state, isA<OtpSentState>());
        expect(c.codeSent, isTrue);
        expect(c.resendIn, 60);
        expect(c.canResend, isFalse);
      }
      expect(api.sent('POST', 'auth/otp'), hasLength(2));
      expect(api.last('POST', 'auth/otp').json, {'phone': '+201012345678'});
    });

    test('registration uses auth/register/otp with the SMS language', () async {
      api.on('POST', 'auth/register/otp', body: apiOk({'resend_in': 60}));
      final c = make(OtpPurpose.register, locale: 'ar');
      await c.sendCode();
      expect(api.last('POST', 'auth/register/otp').json, {
        'phone': '+201012345678',
        'locale': 'ar',
      });
    });

    test('the countdown ticks down to a resend', () async {
      api.on('POST', 'auth/otp', body: apiOk({'resend_in': 2}));
      final c = make(OtpPurpose.login);
      final ticks = <int>[];
      final sub = c.stream.listen((s) {
        if (s is OtpTickState) ticks.add(s.resendIn);
      });
      addTearDown(sub.cancel);

      await c.sendCode();
      expect(c.canResend, isFalse);
      await Future<void>.delayed(const Duration(milliseconds: 2300));

      expect(ticks, [1, 0]);
      expect(c.resendIn, 0);
      expect(c.canResend, isTrue);
    });

    test('resend_wait locks resend for retry_after seconds', () async {
      api.on(
        'POST',
        'auth/otp',
        status: 429,
        body: apiError(ApiErrorCodes.resendWait, retryAfter: 42),
      );
      final c = make(OtpPurpose.login);
      await c.sendCode();
      final state = c.state as OtpSendFailureState;
      expect(state.result.errorCode, ApiErrorCodes.resendWait);
      expect(c.resendIn, 42);
      expect(c.codeSent, isFalse);
    });

    for (final (status, code) in [
      (429, ApiErrorCodes.tooMany),
      (503, ApiErrorCodes.deliveryFailed),
      (409, ApiErrorCodes.phoneAlreadyRegistered),
      (409, ApiErrorCodes.registrationPending),
      (429, ApiErrorCodes.registrationPaused),
    ]) {
      test('$code is reported', () async {
        api.on(
          'POST',
          'auth/register/otp',
          status: status,
          body: apiError(code),
        );
        final c = make(OtpPurpose.register);
        await c.sendCode();
        expect((c.state as OtpSendFailureState).result.errorCode, code);
      });
    }
  });

  group('checking the code (§4.4, §5.2)', () {
    test('login: returns the setup token', () async {
      api.on(
        'POST',
        'auth/otp/verify',
        body: apiOk({'setup_token': '12|kq', 'expires_in': 900}),
      );
      final c = make(OtpPurpose.login);
      c.codeController.text = '123456';
      await c.verify();
      expect((c.state as OtpVerifiedState).token, '12|kq');
      expect(api.last('POST', 'auth/otp/verify').json, {
        'phone': '+201012345678',
        'code': '123456',
      });
    });

    test('register: returns the registration token', () async {
      api.on(
        'POST',
        'auth/register/verify',
        body: apiOk({'registration_token': 'vN3', 'expires_in': 1800}),
      );
      final c = make(OtpPurpose.register);
      c.codeController.text = '654321';
      await c.verify();
      expect((c.state as OtpVerifiedState).token, 'vN3');
    });

    test('an incomplete code is not sent', () async {
      final c = make(OtpPurpose.login);
      c.codeController.text = '123';
      await c.verify();
      expect(api.requests, isEmpty);
    });

    test('invalid: clears the code, resend stays locked', () async {
      api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
      api.on(
        'POST',
        'auth/otp/verify',
        status: 422,
        body: apiError(
          ApiErrorCodes.invalid,
          message: 'Wrong code. 3 tries left.',
        ),
      );
      final c = make(OtpPurpose.login);
      await c.sendCode();
      c.codeController.text = '000000';
      await c.verify();

      final state = c.state as OtpVerifyFailureState;
      expect(state.result.errorCode, ApiErrorCodes.invalid);
      expect(state.result.message, 'Wrong code. 3 tries left.');
      expect(c.codeController.text, isEmpty);
      expect(c.resendIn, greaterThan(0));
    });

    for (final code in [ApiErrorCodes.burned, ApiErrorCodes.expired]) {
      test('$code: a new code can be requested at once', () async {
        api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
        api.on('POST', 'auth/otp/verify', status: 422, body: apiError(code));
        final c = make(OtpPurpose.login);
        await c.sendCode();
        c.codeController.text = '000000';
        await c.verify();

        expect(c.resendIn, 0);
        expect(c.canResend, isTrue);
        expect(c.codeController.text, isEmpty);
      });
    }
  });

  test('Android: the code from the SMS is filled in and checked', () async {
    final sms = Completer<String?>();
    SmsCodeRetriever.listen = () => sms.future;
    api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
    api.on('POST', 'auth/otp/verify', body: apiOk({'setup_token': '12|kq'}));
    final c = make(OtpPurpose.login);

    await c.sendCode();
    sms.complete('482913');
    await settle();

    expect(c.codeController.text, '482913');
    expect(c.state, isA<OtpVerifiedState>());
    expect(api.last('POST', 'auth/otp/verify').json['code'], '482913');
  });

  test('closing stops the countdown and the SMS listener', () async {
    var stopped = 0;
    SmsCodeRetriever.stop = () async => stopped++;
    api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
    final c = OtpController(
      args: const OtpArgs(phone: '+201012345678', purpose: OtpPurpose.login),
    );
    await c.sendCode();
    await c.close();
    await settle();
    expect(stopped, greaterThan(0));
  });
}
