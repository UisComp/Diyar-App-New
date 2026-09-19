import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResult.fromJson', () {
    test('success parses data', () {
      final r = ApiResult<OtpSent>.fromJson(
        {
          'success': true,
          'message': 'We sent a code to +20 101 234 5678.',
          'data': {'expires_in': 300, 'resend_in': 60},
        },
        statusCode: 200,
        parse: OtpSent.fromJson,
      );
      expect(r.success, isTrue);
      expect(r.data!.resendIn, 60);
      expect(r.data!.expiresIn, 300);
      expect(r.errorCode, isNull);
    });

    test('reads errors.code and never treats it as a field error', () {
      final r = ApiResult<void>.fromJson({
        'success': false,
        'message': "This number isn't registered.",
        'errors': {'code': 'phone_not_registered'},
      }, statusCode: 404);
      expect(r.success, isFalse);
      expect(r.errorCode, ApiErrorCodes.phoneNotRegistered);
      expect(r.fieldErrors, isEmpty);
      expect(r.message, "This number isn't registered.");
    });

    test('429 carries retry_after', () {
      final r = ApiResult<void>.fromJson({
        'success': false,
        'message': 'Please wait 42 seconds before requesting another code.',
        'errors': {'code': 'resend_wait', 'retry_after': 42},
      }, statusCode: 429);
      expect(r.errorCode, ApiErrorCodes.resendWait);
      expect(r.retryAfter, 42);
    });

    test('422 validation keeps the field → messages map', () {
      final r = ApiResult<void>.fromJson({
        'success': false,
        'message': 'The given data was invalid.',
        'errors': {
          'unit_code': ['The unit code field is required.'],
          'email': ['The email must be a valid email address.'],
        },
      }, statusCode: 422);
      expect(r.errorCode, isNull);
      expect(r.fieldErrors.keys, containsAll(['unit_code', 'email']));
      expect(r.firstFieldError, 'The unit code field is required.');
    });

    test('a list of plain errors is kept (unit check)', () {
      final r = ApiResult<void>.fromJson({
        'success': false,
        'message': 'Unit is not available',
        'errors': ['Unit code does not exist'],
      }, statusCode: 422);
      expect(r.firstFieldError, 'Unit code does not exist');
    });

    test('a 2xx with success:false is a failure', () {
      final r = ApiResult<void>.fromJson({
        'success': false,
        'message': 'nope',
      }, statusCode: 200);
      expect(r.success, isFalse);
    });

    test('a success missing the expected data is a failure, not a crash', () {
      final r = ApiResult<VerifiedToken>.fromJson(
        {'success': true, 'data': {}},
        statusCode: 200,
        parse: (d) => VerifiedToken.fromJson(d, 'setup_token')!,
      );
      expect(r.success, isFalse);
      expect(r.data, isNull);
    });

    test('non-JSON body (e.g. an HTML error page)', () {
      final r = ApiResult<void>.fromJson('<html>502</html>', statusCode: 502);
      expect(r.success, isFalse);
      expect(r.message, isNull);
      expect(r.isNetworkError, isFalse);
    });

    test('no response at all', () {
      final r = ApiResult<void>.fromResponse(null);
      expect(r.isNetworkError, isTrue);
      expect(r.success, isFalse);
    });
  });

  group('flow models', () {
    test('OtpSent falls back to the documented defaults', () {
      final sent = OtpSent.fromJson({});
      expect(sent.expiresIn, 300);
      expect(sent.resendIn, 60);
      expect(OtpSent.fromJson({'resend_in': '30'}).resendIn, 30);
    });

    test('VerifiedToken reads the right key', () {
      expect(
        VerifiedToken.fromJson({
          'registration_token': 'vN3',
          'expires_in': 1800,
        }, 'registration_token')?.token,
        'vN3',
      );
      expect(
        VerifiedToken.fromJson({'setup_token': ''}, 'setup_token'),
        isNull,
      );
    });

    test('dead codes need a new code', () {
      expect(ApiErrorCodes.isDeadCode('burned'), isTrue);
      expect(ApiErrorCodes.isDeadCode('expired'), isTrue);
      expect(ApiErrorCodes.isDeadCode('invalid'), isFalse);
    });
  });
}
