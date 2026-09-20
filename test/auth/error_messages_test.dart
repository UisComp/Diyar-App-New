import 'dart:convert';
import 'dart:io';

import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Every `errors.code` in MOBILE-API-CHANGES-AUTH.md §11.
const _allCodes = [
  ApiErrorCodes.phoneNotRegistered,
  ApiErrorCodes.accountPending,
  ApiErrorCodes.useEmailLogin,
  ApiErrorCodes.usePhoneLogin,
  ApiErrorCodes.notAllowed,
  ApiErrorCodes.wrongCredentials,
  ApiErrorCodes.passwordNotSet,
  ApiErrorCodes.passwordSetupRequired,
  ApiErrorCodes.invalid,
  ApiErrorCodes.burned,
  ApiErrorCodes.expired,
  ApiErrorCodes.resendWait,
  ApiErrorCodes.tooMany,
  ApiErrorCodes.registrationPaused,
  ApiErrorCodes.deliveryFailed,
  ApiErrorCodes.phoneAlreadyRegistered,
  ApiErrorCodes.registrationPending,
  ApiErrorCodes.registrationTokenInvalid,
  ApiErrorCodes.numberTaken,
  ApiErrorCodes.numberPending,
  ApiErrorCodes.tooManyPending,
  ApiErrorCodes.targetPending,
  ApiErrorCodes.lastNumber,
  ApiErrorCodes.notYourNumber,
  ApiErrorCodes.notPending,
];

ApiResult<void> _error(
  String? code, {
  int status = 422,
  String? message,
  int? retryAfter,
}) => ApiResult<void>.fromJson({
  'success': false,
  if (message != null) 'message': message,
  'errors': {
    if (code != null) 'code': code,
    if (retryAfter != null) 'retry_after': retryAfter,
  },
}, statusCode: status);

void main() {
  test('every error code has an English and an Arabic message', () {
    final en =
        jsonDecode(File('assets/translations/en.json').readAsStringSync())
            as Map<String, dynamic>;
    final ar =
        jsonDecode(File('assets/translations/ar.json').readAsStringSync())
            as Map<String, dynamic>;
    for (final code in _allCodes) {
      final key = apiErrorKey(code);
      expect(key, isNotNull, reason: code);
      expect(en[key], isA<String>(), reason: '$code in en.json');
      expect(ar[key], isA<String>(), reason: '$code in ar.json');
    }
  });

  testWidgets('messages follow the app language', (tester) async {
    late String en, wait, invalid, network, validation, unknown;
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) {
          en = apiErrorMessage(_error(ApiErrorCodes.wrongCredentials));
          wait = apiErrorMessage(
            _error(ApiErrorCodes.resendWait, status: 429, retryAfter: 42),
          );
          invalid = apiErrorMessage(
            _error(ApiErrorCodes.invalid, message: 'Wrong code. 3 tries left.'),
          );
          network = apiErrorMessage(const ApiResult<void>.networkError());
          validation = apiErrorMessage(
            ApiResult<void>.fromJson({
              'success': false,
              'errors': {
                'email': ['The email has already been taken.'],
              },
            }, statusCode: 422),
          );
          unknown = apiErrorMessage(
            _error('brand_new_code', message: 'Server says hi'),
          );
          return const SizedBox();
        },
      ),
    );
    expect(en, 'Wrong phone number, email or password.');
    expect(wait, 'Please wait 42 seconds before requesting another code.');
    // The server's message says how many tries are left.
    expect(invalid, 'Wrong code. 3 tries left.');
    expect(network, 'Please check your internet connection');
    expect(validation, 'The email has already been taken.');
    expect(unknown, 'Server says hi');
  });

  testWidgets('Arabic', (tester) async {
    late String message;
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) {
          message = apiErrorMessage(_error(ApiErrorCodes.phoneNotRegistered));
          return const SizedBox();
        },
      ),
      locale: const Locale('ar'),
    );
    expect(
      message,
      'هذا الرقم غير مسجل. أنشئ حساباً أو تواصل مع مكتب المبيعات.',
    );
  });
}
