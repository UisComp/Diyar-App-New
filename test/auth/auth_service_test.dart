import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

void main() {
  late FakeApi api;
  setUp(() async => api = await setUpAuthTestEnv());

  group('AuthService request contract', () {
    test('phone login sends fcm_token and platform, no bearer', () async {
      await signIn(token: 'someone-else');
      api.on('POST', 'auth/login', body: apiOk(loginData()));
      final r = await AuthService.login(
        login: '+201012345678',
        password: 'secret123',
        fcmToken: 'tok',
        platform: 'ios',
      );
      expect(r.success, isTrue);
      final req = api.last('POST', 'auth/login');
      expect(req.json, {
        'login': '+201012345678',
        'password': 'secret123',
        'fcm_token': 'tok',
        'platform': 'ios',
      });
      expect(req.authorization, isNull);
      expect(req.headers['Accept'], 'application/json');
    });

    test('fcm_token is left out when Firebase has none', () async {
      api.on('POST', 'auth/login', body: apiOk(loginData()));
      await AuthService.login(
        login: '+201012345678',
        password: 'secret123',
        platform: 'android',
      );
      expect(
        api.last('POST', 'auth/login').json.containsKey('fcm_token'),
        isFalse,
      );
    });

    test('set password authenticates with the setup token only', () async {
      await signIn(token: 'stale-login');
      api.on('POST', 'auth/password', body: apiOk(loginData()));
      final r = await AuthService.setPassword(
        setupToken: '12|setup',
        password: 'secret123',
        passwordConfirmation: 'secret123',
        fcmToken: 'tok',
        platform: 'android',
      );
      expect(r.success, isTrue);
      final req = api.last('POST', 'auth/password');
      expect(req.authorization, 'Bearer 12|setup');
      expect(req.json, {
        'password': 'secret123',
        'password_confirmation': 'secret123',
        'fcm_token': 'tok',
        'platform': 'android',
      });
    });

    test(
      'registration: units and password, no project; email optional',
      () async {
        api.on('POST', 'auth/register', status: 201, body: apiOk(userJson()));
        final r = await AuthService.register(
          registrationToken: 'vN3',
          name: 'John Doe',
          unitCodes: ['B1-G-01', 'T-12-S'],
          password: 'secret123',
          passwordConfirmation: 'secret123',
          locale: 'ar',
        );
        expect(r.success, isTrue);
        expect(api.last('POST', 'auth/register').json, {
          'registration_token': 'vN3',
          'name': 'John Doe',
          'unit_codes': ['B1-G-01', 'T-12-S'],
          'password': 'secret123',
          'password_confirmation': 'secret123',
          'locale': 'ar',
        });
      },
    );

    test('registration code carries the SMS language', () async {
      api.on('POST', 'auth/register/otp', body: apiOk({'resend_in': 60}));
      await AuthService.requestRegisterOtp(phone: '01012345678', locale: 'en');
      expect(api.last('POST', 'auth/register/otp').json, {
        'phone': '01012345678',
        'locale': 'en',
      });
    });

    test('an email goes to the same endpoint, in `login`', () async {
      api.onRequest(
        'POST',
        'auth/login',
        (_) => FakeResponse(
          403,
          apiError(ApiErrorCodes.usePhoneLogin, message: 'Use your phone'),
        ),
      );
      final r = await AuthService.login(
        login: 'resident@example.com',
        password: 'secret123',
        fcmToken: 'tok',
        platform: 'android',
      );
      expect(r.success, isFalse);
      expect(r.errorCode, ApiErrorCodes.usePhoneLogin);
      expect(api.last('POST', 'auth/login').json, {
        'login': 'resident@example.com',
        'password': 'secret123',
        'fcm_token': 'tok',
        'platform': 'android',
      });
      expect(api.sent('POST', 'login'), isEmpty);
    });

    test('offline is a network error, not an exception', () async {
      api.offline('POST', 'auth/otp');
      final r = await AuthService.requestLoginOtp(phone: '01012345678');
      expect(r.isNetworkError, isTrue);
    });
  });

  group('AuthSession', () {
    test('start saves the login and syncs the language', () async {
      await HiveHelper.addToHive(
        key: AppConstants.myCurrentLanguagekey,
        value: 'ar',
      );
      api.on('PATCH', 'profile', body: apiOk(userJson()));
      api.on('POST', 'auth/login', body: apiOk(loginData(token: '99|t')));
      final login = (await AuthService.login(
        login: '+201012345678',
        password: 'x',
        platform: 'android',
      )).data!;

      await AuthSession.start(
        login,
        identifier: '+201012345678',
        password: 'secret123',
      );
      await settle();

      expect(AuthSession.isLoggedIn, isTrue);
      expect(AuthSession.isResident, isTrue);
      expect(await HiveHelper.getFromHive(key: AppConstants.token), '99|t');
      final stored = await HiveHelper.getUserModel(AppConstants.userModelKey);
      expect(stored!.data!.accessToken, '99|t');
      expect(
        await HiveHelper.getFromHive(key: AppConstants.myEmail),
        '+201012345678',
      );
      expect(
        await secureStorage.read(key: AppConstants.myPassword),
        'secret123',
      );
      final patch = api.last('PATCH', 'profile');
      expect(patch.json, {'locale': 'ar'});
      expect(patch.authorization, 'Bearer 99|t');
    });

    test('clear forgets the login but keeps biometric credentials', () async {
      await signIn();
      await savedCredentials(identifier: '+201012345678', password: 'p4ssword');
      await AuthSession.clear();
      expect(AuthSession.isLoggedIn, isFalse);
      expect(await HiveHelper.getFromHive(key: AppConstants.token), isNull);
      expect(await HiveHelper.getUserModel(AppConstants.userModelKey), isNull);
      expect(
        await secureStorage.read(key: AppConstants.myPassword),
        'p4ssword',
      );
    });

    test('guards are not residents', () async {
      await signIn(roles: ['guard']);
      expect(AuthSession.isGuard, isTrue);
      expect(AuthSession.isResident, isFalse);
    });

    test(
      'a rotated push token replaces this device only when signed in',
      () async {
        api.on('POST', 'profile/fcm-token', body: apiOk(null));
        await AuthSession.onPushTokenRefreshed('new-token');
        expect(api.sent('POST', 'profile/fcm-token'), isEmpty);

        await signIn(token: '5|me');
        await AuthSession.onPushTokenRefreshed('new-token');
        final req = api.last('POST', 'profile/fcm-token');
        expect(req.json, {
          'fcm_token': 'new-token',
          'platform': DeviceHelper.platform,
        });
        expect(req.authorization, 'Bearer 5|me');
      },
    );

    test('language sync does nothing when signed out', () async {
      await AuthSession.syncLocale('en');
      expect(api.sent('PATCH', 'profile'), isEmpty);
    });
  });
}
