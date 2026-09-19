import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/controller/login_controller.dart';
import 'package:diyar_app/feature/auth/controller/login_state.dart';
import 'package:diyar_app/feature/auth/model/login_identifier.dart';
import 'package:diyar_app/feature/auth/controller/set_password_controller.dart';
import 'package:diyar_app/feature/auth/controller/set_password_state.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

void main() {
  late FakeApi api;
  setUp(() async {
    api = await setUpAuthTestEnv();
    // The locale sync after each login.
    api.on('PATCH', 'profile', body: apiOk(userJson()));
  });

  group('LoginIdentifier', () {
    test('emails are trimmed and lower-cased', () {
      final id = LoginIdentifier.tryParse('  Guard@LaMer.com ')!;
      expect(id.isEmail, isTrue);
      expect(id.value, 'guard@lamer.com');
    });

    test('Egyptian numbers in any common form', () {
      for (final input in [
        '01012345678',
        '010 1234 5678',
        '010-1234-5678',
        '+20 101 234 5678',
        '00201012345678',
        '٠١٠١٢٣٤٥٦٧٨',
      ]) {
        final id = LoginIdentifier.tryParse(input);
        expect(id?.isPhone, isTrue, reason: input);
        expect(id?.value, '+201012345678', reason: input);
      }
    });

    test('other countries need their code', () {
      expect(LoginIdentifier.tryParse('+971501234567')?.value, '+971501234567');
    });

    test('rejects what is neither', () {
      for (final input in [
        '',
        '   ',
        'abc',
        'john@',
        '12345',
        '01a012345678',
      ]) {
        expect(LoginIdentifier.tryParse(input), isNull, reason: input);
      }
    });
  });

  group('LoginController: one login for everyone', () {
    /// A phone number goes in the phone field (Egypt picked), an email in
    /// the email field.
    LoginController make(String identifier, {String password = 'secret123'}) {
      final c = LoginController();
      addTearDown(c.close);
      if (identifier.contains('@')) {
        c.setUseEmail(true);
        c.emailController.text = identifier;
      } else {
        c.phoneController.value = PhoneNumber.parse(
          identifier,
          callerCountry: IsoCode.EG,
        );
      }
      c.passwordController.text = password;
      return c;
    }

    test('a phone number uses the resident login, no SMS', () async {
      api.on('POST', 'auth/login', body: apiOk(loginData(token: '13|Zp')));
      final c = make('01012345678');

      await c.login();

      expect(c.state, isA<SignInSuccessState>());
      expect(userModel?.data?.accessToken, '13|Zp');
      expect(api.last('POST', 'auth/login').json, {
        'login': '+201012345678',
        'password': 'secret123',
        'fcm_token': testFcmToken,
        'platform': anyOf('android', 'ios'),
      });
      expect(api.sent('POST', 'auth/otp'), isEmpty);
      expect(api.sent('POST', 'login'), isEmpty);
      // Kept for biometric sign-in.
      expect(
        await HiveHelper.getFromHive(key: AppConstants.myEmail),
        '+201012345678',
      );
    });

    test('an email uses the security staff login', () async {
      api.on(
        'POST',
        'auth/login',
        body: apiOk(loginData(user: userJson(roles: ['guard']))),
      );
      final c = make(' Guard@LaMer.com ');

      await c.login();

      expect(c.state, isA<SignInSuccessState>());
      expect(api.last('POST', 'auth/login').json, {
        'login': 'guard@lamer.com',
        'password': 'secret123',
        'fcm_token': testFcmToken,
        'platform': anyOf('android', 'ios'),
      });
      expect(api.sent('POST', 'login'), isEmpty);
      expect(AuthSession.isGuard, isTrue);
    });

    test('nothing is sent for an invalid number or email', () async {
      final c = make('01012345678');
      c.phoneController.value = const PhoneNumber(
        isoCode: IsoCode.EG,
        nsn: '123',
      );
      await c.login();
      c.setUseEmail(true);
      c.emailController.text = 'john@';
      await c.login();
      expect(api.requests, isEmpty);
    });

    test(
      'another country from the picker is sent in international form',
      () async {
        api.on('POST', 'auth/login', body: apiOk(loginData()));
        final c = make('01012345678');
        c.phoneController.value = const PhoneNumber(
          isoCode: IsoCode.AE,
          nsn: '501234567',
        );
        await c.login();
        expect(api.last('POST', 'auth/login').json['login'], '+971501234567');
      },
    );

    test(
      'switching fields: the email field is only read in email mode',
      () async {
        api.on('POST', 'auth/login', body: apiOk(loginData()));
        final c = make('01012345678');
        c.emailController.text = 'guard@lamer.com';
        await c.login();
        expect(api.last('POST', 'auth/login').json['login'], '+201012345678');
      },
    );

    test('password_not_set keeps the phone to text a code', () async {
      api.on(
        'POST',
        'auth/login',
        status: 409,
        body: apiError(ApiErrorCodes.passwordNotSet),
      );
      final c = make('01012345678');

      await c.login();

      final state = c.state as SignInFailureState;
      expect(state.result.errorCode, ApiErrorCodes.passwordNotSet);
      expect(state.phone, '+201012345678');
      expect(AuthSession.isLoggedIn, isFalse);
    });

    for (final (endpoint, id, status, code) in [
      ('auth/login', '01012345678', 401, ApiErrorCodes.wrongCredentials),
      ('auth/login', '01012345678', 403, ApiErrorCodes.accountPending),
      ('auth/login', '01012345678', 403, ApiErrorCodes.useEmailLogin),
      ('auth/login', 'resident@example.com', 403, ApiErrorCodes.usePhoneLogin),
      ('auth/login', 'office@lamer.com', 403, ApiErrorCodes.notAllowed),
      ('auth/login', 'guard@lamer.com', 401, ApiErrorCodes.wrongCredentials),
    ]) {
      test('$code fails without a session', () async {
        api.on('POST', endpoint, status: status, body: apiError(code));
        final c = make(id);

        await c.login();

        expect((c.state as SignInFailureState).result.errorCode, code);
        expect(AuthSession.isLoggedIn, isFalse);
      });
    }

    test('ignores a second tap while the first is running', () async {
      api.on('POST', 'auth/login', body: apiOk(loginData()));
      final c = make('01012345678');
      await Future.wait([c.login(), c.login()]);
      expect(api.sent('POST', 'auth/login'), hasLength(1));
    });
  });

  group('biometric sign-in with saved credentials', () {
    LoginController make() {
      final c = LoginController();
      addTearDown(c.close);
      return c;
    }

    test('nothing saved', () async {
      final c = make();
      await c.loginWithSavedCredentials();
      expect(c.state, isA<NoSavedLoginState>());
    });

    test('a saved phone number uses the resident login', () async {
      await savedCredentials(identifier: '+201012345678', password: 'pw123456');
      api.on('POST', 'auth/login', body: apiOk(loginData()));
      final c = make();

      await c.loginWithSavedCredentials();

      expect(c.state, isA<SignInSuccessState>());
      expect(api.last('POST', 'auth/login').json['login'], '+201012345678');
      expect(api.sent('POST', 'login'), isEmpty);
    });

    test('a saved email uses the staff login', () async {
      await savedCredentials(
        identifier: 'guard@lamer.com',
        password: 'pw123456',
      );
      api.on(
        'POST',
        'auth/login',
        body: apiOk(loginData(user: userJson(roles: ['guard']))),
      );
      final c = make();

      await c.loginWithSavedCredentials();

      expect(c.state, isA<SignInSuccessState>());
      expect(api.last('POST', 'auth/login').json['login'], 'guard@lamer.com');
    });

    test("a resident's old saved email is forgotten, biometric off", () async {
      await savedCredentials(
        identifier: 'old@example.com',
        password: 'pw123456',
      );
      await saveBiometricStatus(true);
      api.on(
        'POST',
        'auth/login',
        status: 403,
        body: apiError(ApiErrorCodes.usePhoneLogin),
      );
      final c = make();

      await c.loginWithSavedCredentials();

      expect((c.state as SignInFailureState).savedLoginOutdated, isTrue);
      expect(await HiveHelper.getFromHive(key: AppConstants.myEmail), isNull);
      expect(await secureStorage.read(key: AppConstants.myPassword), isNull);
      expect(enableBiometric, isFalse);
    });

    test('a network error keeps the saved credentials', () async {
      await savedCredentials(identifier: '+201012345678', password: 'pw123456');
      api.offline('POST', 'auth/login');
      final c = make();

      await c.loginWithSavedCredentials();

      final state = c.state as SignInFailureState;
      expect(state.savedLoginOutdated, isFalse);
      expect(state.result.isNetworkError, isTrue);
      expect(
        await secureStorage.read(key: AppConstants.myPassword),
        'pw123456',
      );
    });
  });

  group('SetPasswordController (§4.5)', () {
    SetPasswordController make() {
      final c = SetPasswordController(
        args: const SetPasswordArgs(
          phone: '+201012345678',
          setupToken: '12|kq',
        ),
      );
      addTearDown(c.close);
      c.passwordController.text = 'secret123';
      c.confirmationController.text = 'secret123';
      return c;
    }

    test('success logs in with the new token', () async {
      api.on(
        'POST',
        'auth/password',
        body: apiOk(loginData(token: '13|new'), message: 'Password set.'),
      );
      final c = make();

      await c.submit();

      expect(c.state, isA<SetPasswordSuccessState>());
      expect(userModel?.data?.accessToken, '13|new');
      final req = api.last('POST', 'auth/password');
      expect(req.authorization, 'Bearer 12|kq');
      expect(req.json['fcm_token'], testFcmToken);
      expect(
        await secureStorage.read(key: AppConstants.myPassword),
        'secret123',
      );
    });

    test('an expired setup token asks to verify again', () async {
      api.on(
        'POST',
        'auth/password',
        status: 401,
        body: {'message': 'Unauthenticated.'},
      );
      final c = make();

      await c.submit();

      expect((c.state as SetPasswordFailureState).tokenExpired, isTrue);
      expect(AuthSession.isLoggedIn, isFalse);
    });

    test('a validation error is shown, token still usable', () async {
      api.on(
        'POST',
        'auth/password',
        status: 422,
        body: {
          'success': false,
          'message': 'The given data was invalid.',
          'errors': {
            'password': ['The password must be at least 8 characters.'],
          },
        },
      );
      final c = make();

      await c.submit();

      final state = c.state as SetPasswordFailureState;
      expect(state.tokenExpired, isFalse);
      expect(
        state.result.firstFieldError,
        'The password must be at least 8 characters.',
      );
    });
  });

  group('AuthController (logout)', () {
    test('logout clears the session even when the request fails', () async {
      await signIn();
      await HiveHelper.addToHive(key: AppConstants.token, value: '13|access');
      api.offline('POST', 'logout');
      final c = AuthController();
      addTearDown(c.close);

      await c.logOut();

      expect(c.state, isA<LogOutFailureState>());
      expect(AuthSession.isLoggedIn, isFalse);
      expect(await HiveHelper.getFromHive(key: AppConstants.token), isNull);
    });

    test('logout success', () async {
      await signIn();
      api.on('POST', 'logout', body: apiOk(null, message: 'Logged out'));
      final c = AuthController();
      addTearDown(c.close);

      await c.logOut();

      expect(c.state, isA<LogOutSuccessState>());
      expect(api.last('POST', 'logout').authorization, 'Bearer 13|access');
      expect(AuthSession.isLoggedIn, isFalse);
    });
  });
}
