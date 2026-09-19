import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/feature/auth/controller/register_controller.dart';
import 'package:diyar_app/feature/auth/controller/register_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

void main() {
  late FakeApi api;
  setUp(() async => api = await setUpAuthTestEnv());

  RegisterController make() {
    final c = RegisterController(
      args: const RegisterDetailsArgs(
        phone: '+201012345678',
        registrationToken: 'vN3',
      ),
    );
    addTearDown(c.close);
    return c;
  }

  group('units', () {
    test('starts with one unit row; add up to the limit, remove', () {
      final c = make();
      expect(c.units, hasLength(1));
      for (var i = 1; i < RegisterController.maxUnits + 3; i++) {
        c.addUnit();
      }
      expect(c.units, hasLength(RegisterController.maxUnits));
      expect(c.canAddUnit, isFalse);

      c.removeUnit(c.units.last);
      expect(c.units, hasLength(RegisterController.maxUnits - 1));
      while (c.units.length > 1) {
        c.removeUnit(c.units.last);
      }
      // The last row stays: at least one unit is required.
      c.removeUnit(c.units.single);
      expect(c.units, hasLength(1));
    });

    test('codes are normalised, blanks and duplicates dropped', () {
      final c = make();
      c.units.first.controller.text = ' b1-g-01 ';
      c.addUnit();
      c.units[1].controller.text = 'T-12-S';
      c.addUnit();
      c.units[2].controller.text = 'B1-G-01';
      c.addUnit();

      expect(c.unitCodes, ['B1-G-01', 'T-12-S']);
      expect(c.isDuplicate(c.units[2]), isTrue);
      expect(c.isDuplicate(c.units[0]), isFalse);
      expect(c.isDuplicate(c.units[1]), isFalse);
      expect(c.isDuplicate(c.units[3]), isFalse);
    });
  });

  // The availability endpoint is deprecated (MOBILE-API-CHANGES-MASTER-PLAN
  // §6): it no longer looks codes up, so the form doesn't call it.
  test('typing a unit code sends no request', () async {
    final c = make();
    for (final text in ['B', 'B1', 'B1-', 'B1-G-01']) {
      c.units.first.controller.text = text;
    }
    await Future<void>.delayed(const Duration(milliseconds: 800));

    expect(api.requests, isEmpty);
    expect(c.units.first.code, 'B1-G-01');
  });

  group('submit', () {
    RegisterController filled() {
      final c = make();
      c.nameController.text = '  John Doe ';
      c.emailController.text = 'john@example.com';
      c.units.first.controller.text = 'b1-g-01';
      c.addUnit();
      c.units[1].controller.text = 't-12-s';
      c.passwordController.text = 'secret123';
      c.confirmationController.text = 'secret123';
      return c;
    }

    test('sends every unit and the password', () async {
      api.on('POST', 'auth/register', status: 201, body: apiOk(userJson()));
      final c = filled();

      await c.submit(locale: 'ar');

      expect(c.state, isA<RegisterSuccessState>());
      expect(api.last('POST', 'auth/register').json, {
        'registration_token': 'vN3',
        'name': 'John Doe',
        'email': 'john@example.com',
        'unit_codes': ['B1-G-01', 'T-12-S'],
        'password': 'secret123',
        'password_confirmation': 'secret123',
        'locale': 'ar',
      });
    });

    test('a blank email is left out', () async {
      api.on('POST', 'auth/register', status: 201, body: apiOk(userJson()));
      final c = filled();
      c.emailController.text = '   ';

      await c.submit(locale: 'en');

      expect(
        api.last('POST', 'auth/register').json.containsKey('email'),
        isFalse,
      );
    });

    test('nothing is sent without a unit code', () async {
      final c = make();
      c.nameController.text = 'John';
      await c.submit(locale: 'en');
      expect(api.requests, isEmpty);
    });

    test('an expired token asks to verify the number again', () async {
      api.on(
        'POST',
        'auth/register',
        status: 422,
        body: apiError(ApiErrorCodes.registrationTokenInvalid),
      );
      final c = filled();
      await c.submit(locale: 'en');
      expect((c.state as RegisterFailureState).mustVerifyAgain, isTrue);
    });

    test('a per-unit validation error is shown, token kept', () async {
      api.on(
        'POST',
        'auth/register',
        status: 422,
        body: {
          'success': false,
          'message': 'The given data was invalid.',
          'errors': {
            'unit_codes.1': ['Unit is already assigned to another user'],
          },
        },
      );
      final c = filled();
      await c.submit(locale: 'en');
      final state = c.state as RegisterFailureState;
      expect(state.mustVerifyAgain, isFalse);
      expect(
        state.result.firstFieldError,
        'Unit is already assigned to another user',
      );
    });
  });

  group('server messages under their fields (§5.4)', () {
    test(
      'unit_codes.<i> is the i-th code sent, blanks and repeats skipped',
      () async {
        api.on(
          'POST',
          'auth/register',
          status: 422,
          body: {
            'success': false,
            'message': 'Unit code must not be longer than 50 characters.',
            'errors': {
              'unit_codes.1': [
                'Unit code must not be longer than 50 characters.',
              ],
              'email': ['Email is already taken'],
              'password': ['The password must be at least 8 characters.'],
            },
          },
        );
        final c = make();
        c.nameController.text = 'John';
        c.emailController.text = 'john@example.com';
        c.units.first.controller.text = 'B1-G-01';
        c.addUnit(); // blank: not sent
        c.addUnit();
        c.units[2].controller.text = 'b1-g-01'; // repeat: not sent
        c.addUnit();
        c.units[3].controller.text = 'T-12-S'; // sent second: unit_codes.1
        c.passwordController.text = 'short';
        c.confirmationController.text = 'short';

        await c.submit(locale: 'en');

        expect(api.last('POST', 'auth/register').json['unit_codes'], [
          'B1-G-01',
          'T-12-S',
        ]);
        expect(c.hasInlineErrors, isTrue);
        expect(
          c.units[3].serverError,
          'Unit code must not be longer than 50 characters.',
        );
        expect(c.units[0].serverError, isNull);
        expect(c.fieldErrors['email'], 'Email is already taken');
        expect(
          c.fieldErrors['password'],
          'The password must be at least 8 characters.',
        );

        // Editing a field clears its message.
        c.units[3].controller.text = 'T-12';
        c.emailController.text = 'other@example.com';
        expect(c.units[3].serverError, isNull);
        expect(c.fieldErrors.containsKey('email'), isFalse);
        expect(c.fieldErrors.containsKey('password'), isTrue);
      },
    );

    test('"unit_codes" itself goes under the first row', () async {
      api.on(
        'POST',
        'auth/register',
        status: 422,
        body: {
          'success': false,
          'errors': {
            'unit_codes': ['You can add at most 10 units.'],
          },
        },
      );
      final c = make();
      c.units.first.controller.text = 'B1-G-01';
      await c.submit(locale: 'en');
      expect(c.units.first.serverError, 'You can add at most 10 units.');
    });

    test('a new submit clears the old messages', () async {
      api.on(
        'POST',
        'auth/register',
        status: 422,
        body: {
          'success': false,
          'errors': {
            'name': ['Name is required'],
          },
        },
      );
      api.on('POST', 'auth/register', status: 201, body: apiOk(userJson()));
      final c = make();
      c.units.first.controller.text = 'B1-G-01';
      await c.submit(locale: 'en');
      expect(c.fieldErrors['name'], 'Name is required');

      await c.submit(locale: 'en');
      expect(c.state, isA<RegisterSuccessState>());
      expect(c.hasInlineErrors, isFalse);
    });
  });
}
