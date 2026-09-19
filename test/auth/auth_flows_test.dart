// End-to-end flows through the real routes, screens and controllers, with
// the backend faked (MOBILE-API-CHANGES-AUTH.md §4–§7, §10).
import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/routes/app_routes.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';
import '../helpers/test_app.dart';

const _authRoutes = {
  RoutesName.login,
  RoutesName.phoneOtpScreen,
  RoutesName.setPasswordScreen,
  RoutesName.register,
  RoutesName.registerDetailsScreen,
  RoutesName.registrationPendingScreen,
  RoutesName.phoneNumbersScreen,
  RoutesName.forgetPasswordScreen,
};

/// The app's own auth routes, plus a stand-in home.
GoRouter _router({String initial = RoutesName.login, Object? extra}) =>
    GoRouter(
      initialLocation: initial,
      initialExtra: extra,
      routes: [
        for (final route in router.configuration.routes)
          if (route is GoRoute && _authRoutes.contains(route.path)) route,
        GoRoute(
          path: RoutesName.homeLayout,
          builder: (_, _) => const Scaffold(body: Center(child: Text('HOME'))),
        ),
      ],
    );

Widget _providers(Widget app) => MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AppThemeController()),
    BlocProvider(create: (_) => SettingsController()),
  ],
  child: app,
);

void main() {
  late FakeApi api;

  setUp(() async {
    api = await setUpAuthTestEnv(inMemoryHive: true);
    api.on('PATCH', 'profile', body: apiOk(userJson()));
  });

  /// Lets requests finish between frames.
  Future<void> run(WidgetTester tester, {int frames = 12}) async {
    for (var i = 0; i < frames; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump(const Duration(milliseconds: 60));
    }
  }

  /// Signs in (the in-memory Hive keeps this synchronous enough).
  Future<void> signedIn(WidgetTester tester) async {
    signIn();
    await run(tester, frames: 2);
  }

  Future<void> start(
    WidgetTester tester, {
    String initial = RoutesName.login,
    Object? extra,
    Locale locale = const Locale('en'),
  }) => pumpLocalizedRouter(
    tester,
    _router(initial: initial, extra: extra),
    wrap: _providers,
    locale: locale,
    settle: false,
  );

  /// Lets toasts time out so no timer outlives the test.
  Future<void> finish(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> typePhone(WidgetTester tester, String nsn) async {
    await tester.enterText(
      find.descendant(
        of: find.byType(PhoneFormField),
        matching: find.byType(TextField),
      ),
      nsn,
    );
    await tester.pump();
  }

  Future<void> typeCode(WidgetTester tester, String code) async {
    await tester.enterText(
      find.descendant(
        of: find.byType(PinCodeTextField),
        matching: find.byType(TextField),
      ),
      code,
    );
    await run(tester);
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await run(tester);
  }

  /// Fills the login screen: a number in the phone field (Egypt), or an
  /// email after switching to the "Security staff" segment.
  Future<void> typeIdentifier(WidgetTester tester, String identifier) async {
    if (identifier.contains('@')) {
      await tapText(tester, 'Security staff');
      await tester.enterText(find.byType(TextFormField).first, identifier);
    } else {
      await tapText(tester, 'Resident');
      // The national number; the picker already shows +20.
      await typePhone(tester, identifier.replaceFirst(RegExp(r'^0'), ''));
    }
    await tester.pump();
  }

  Future<void> typeLogin(
    WidgetTester tester,
    String identifier, [
    String password = 'secret123',
  ]) async {
    await typeIdentifier(tester, identifier);
    await tester.enterText(find.byType(TextFormField).last, password);
    await tester.pump();
  }

  testWidgets('phone + password on one screen, no SMS', (tester) async {
    api.on('POST', 'auth/login', body: apiOk(loginData(token: '13|Zp')));
    await start(tester);
    await run(tester);

    expect(find.byType(CountryButton), findsOneWidget);
    expect(find.text('+ 20'), findsOneWidget);
    await typeLogin(tester, '01012345678');
    await tapText(tester, 'Sign In');

    expect(find.text('HOME'), findsOneWidget);
    expect(userModel?.data?.accessToken, '13|Zp');
    expect(api.last('POST', 'auth/login').json, {
      'login': '+201012345678',
      'password': 'secret123',
      'fcm_token': testFcmToken,
      'platform': anyOf('android', 'ios'),
    });
    expect(api.sent('POST', 'auth/otp'), isEmpty);
    await finish(tester);
  });

  testWidgets('security staff use the same screen with their email', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/login',
      body: apiOk(loginData(user: userJson(roles: ['guard']))),
    );
    await start(tester);
    await run(tester);

    await typeLogin(tester, 'guard@lamer.com');
    await tapText(tester, 'Sign In');

    expect(find.text('HOME'), findsOneWidget);
    expect(api.last('POST', 'auth/login').json['login'], 'guard@lamer.com');
    expect(api.sent('POST', 'login'), isEmpty);
    await finish(tester);
  });

  testWidgets('empty or invalid fields are caught before any request', (
    tester,
  ) async {
    await start(tester);
    await run(tester);

    await tapText(tester, 'Sign In');
    expect(find.text('Please enter your phone'), findsOneWidget);

    await typeLogin(tester, 'john@');
    await tapText(tester, 'Sign In');
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(api.requests, isEmpty);
    await finish(tester);
  });

  testWidgets('the country picker lists Egypt and the Gulf first', (
    tester,
  ) async {
    await start(tester);
    await run(tester);

    await tester.tap(find.byType(CountryButton));
    await run(tester);
    expect(find.text('Egypt'), findsWidgets);
    expect(find.text('Saudi Arabia'), findsWidgets);
    expect(find.text('United Arab Emirates'), findsWidgets);
    await finish(tester);
  });

  testWidgets('first login by SMS code: code, then set password', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/otp',
      body: apiOk({'expires_in': 300, 'resend_in': 60}),
    );
    api.on('POST', 'auth/otp/verify', body: apiOk({'setup_token': '12|kq'}));
    api.on('POST', 'auth/password', body: apiOk(loginData(token: '13|new')));
    await start(tester);
    await run(tester);

    await typeIdentifier(tester, '01012345678');
    await tapText(tester, 'Sign in with SMS code');

    // The code is texted only now, because it was asked for.
    expect(find.text('Verify your number'), findsOneWidget);
    expect(api.last('POST', 'auth/otp').json, {'phone': '+201012345678'});
    expect(find.textContaining('Resend code in'), findsOneWidget);

    await typeCode(tester, '123456');
    expect(api.last('POST', 'auth/otp/verify').json['code'], '123456');
    expect(find.text('Set your password'), findsWidgets);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'secret123');
    await tester.enterText(fields.at(1), 'secret123');
    await tapText(tester, 'Save and sign in');

    expect(find.text('HOME'), findsOneWidget);
    expect(api.last('POST', 'auth/password').authorization, 'Bearer 12|kq');
    expect(userModel?.data?.accessToken, '13|new');
    await finish(tester);
  });

  testWidgets('SMS code needs a phone number', (tester) async {
    await start(tester);
    await run(tester);

    await typeIdentifier(tester, 'guard@lamer.com');
    await tapText(tester, 'Sign in with SMS code');

    expect(
      find.text(
        'Enter your phone number first. SMS codes go to phone numbers.',
      ),
      findsOneWidget,
    );
    expect(api.requests, isEmpty);
    await finish(tester);
  });

  testWidgets('password_not_set offers to text a code', (tester) async {
    api.on(
      'POST',
      'auth/login',
      status: 409,
      body: apiError(ApiErrorCodes.passwordNotSet),
    );
    api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
    await start(tester);
    await run(tester);

    await typeLogin(tester, '01012345678');
    await tapText(tester, 'Sign In');

    expect(
      find.text(
        "You haven't set a password yet. We'll text you a code so you can "
        'set one.',
      ),
      findsOneWidget,
    );
    // Nothing is texted until the resident agrees.
    expect(api.sent('POST', 'auth/otp'), isEmpty);
    await tapText(tester, 'Send code');

    expect(find.text('Verify your number'), findsOneWidget);
    expect(api.sent('POST', 'auth/otp'), hasLength(1));
    await finish(tester);
  });

  testWidgets('forgot password: a phone number resets by SMS', (tester) async {
    api.on('POST', 'auth/otp', body: apiOk({'resend_in': 60}));
    await start(tester);
    await run(tester);

    await typeIdentifier(tester, '01012345678');
    await tapText(tester, 'Forget Password?');

    expect(find.text('Verify your number'), findsOneWidget);
    expect(api.last('POST', 'auth/otp').json, {'phone': '+201012345678'});
    await finish(tester);
  });

  testWidgets('forgot password: an email uses the staff email reset', (
    tester,
  ) async {
    await start(tester);
    await run(tester);

    await typeIdentifier(tester, 'guard@lamer.com');
    await tapText(tester, 'Forget Password?');

    // The email reset screen, with the email already filled in.
    expect(find.text('guard@lamer.com'), findsOneWidget);
    expect(api.sent('POST', 'auth/otp'), isEmpty);
    await finish(tester);
  });

  testWidgets('an unregistered number on SMS code: offer to sign up', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/otp',
      status: 404,
      body: apiError(ApiErrorCodes.phoneNotRegistered),
    );
    await start(tester);
    await run(tester);

    await typeIdentifier(tester, '01012345678');
    await tapText(tester, 'Sign in with SMS code');

    expect(find.text('Number not registered'), findsOneWidget);
    await tapText(tester, 'Sign Up');

    // Registration opens with the number already filled in.
    expect(find.text('Start by verifying your mobile number'), findsOneWidget);
    final phoneField = tester.widget<TextField>(
      find.descendant(
        of: find.byType(PhoneFormField),
        matching: find.byType(TextField),
      ),
    );
    expect(phoneField.controller!.text.replaceAll(' ', ''), '1012345678');
    await finish(tester);
  });

  testWidgets("a staff member's phone number: use the work email", (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/login',
      status: 403,
      body: apiError(ApiErrorCodes.useEmailLogin),
    );
    await start(tester);
    await run(tester);

    await typeLogin(tester, '01012345678');
    await tapText(tester, 'Sign In');

    expect(
      find.text('Security staff sign in with their work email.'),
      findsOneWidget,
    );
    await finish(tester);
  });

  testWidgets('wrong password: the message matches what was typed', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/login',
      status: 401,
      body: apiError(ApiErrorCodes.wrongCredentials),
    );
    await start(tester);
    await run(tester);

    await typeLogin(tester, '01012345678');
    await tapText(tester, 'Sign In');
    expect(find.text('Wrong phone number or password.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));

    await typeLogin(tester, 'guard@lamer.com');
    await tapText(tester, 'Sign In');
    expect(find.text('Wrong email or password.'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('registration errors appear under the right fields', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/register',
      status: 422,
      body: {
        'success': false,
        'message': 'Email is already taken',
        'errors': {
          'email': ['Email is already taken'],
          'unit_codes.1': ['Unit code must not be longer than 50 characters.'],
        },
      },
    );
    await start(
      tester,
      initial: RoutesName.registerDetailsScreen,
      extra: const RegisterDetailsArgs(
        phone: '+201012345678',
        registrationToken: 'vN3',
      ),
    );
    await run(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'John Doe');
    await tester.enterText(fields.at(1), 'taken@example.com');
    await tester.enterText(fields.at(2), 'B1-G-01');
    await tapText(tester, 'Add another unit');
    await tester.enterText(fields.at(3), 'T-12-S');
    await tester.enterText(fields.at(4), 'secret123');
    await tester.enterText(fields.at(5), 'secret123');
    await tapText(tester, 'Submit registration');

    expect(find.text('Please fix the highlighted fields.'), findsOneWidget);
    expect(find.text('Email is already taken'), findsOneWidget);
    expect(
      find.text('Unit code must not be longer than 50 characters.'),
      findsOneWidget,
    );
    // Still on the form: the token wasn't used up.
    expect(find.text('Your details'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('sign up and back to sign in', (tester) async {
    await start(tester);
    await run(tester);

    await tapText(tester, 'Sign Up');
    expect(find.text('Start by verifying your mobile number'), findsOneWidget);
    await tapText(tester, 'Sign In');
    expect(find.byType(CountryButton), findsOneWidget);
    await finish(tester);
  });

  testWidgets('registration: phone, code, details, under review', (
    tester,
  ) async {
    api.on('POST', 'auth/register/otp', body: apiOk({'resend_in': 60}));
    api.on(
      'POST',
      'auth/register/verify',
      body: apiOk({'registration_token': 'vN3', 'expires_in': 1800}),
    );
    api.on('POST', 'auth/register', status: 201, body: apiOk(userJson()));
    await start(tester, initial: RoutesName.register);
    await run(tester);

    await typePhone(tester, '1012345678');
    await tapText(tester, 'Verify number');
    expect(api.last('POST', 'auth/register/otp').json, {
      'phone': '+201012345678',
      'locale': 'en',
    });

    await typeCode(tester, '654321');
    expect(find.text('Your details'), findsOneWidget);
    expect(find.text('+20 10 12345678'), findsOneWidget);
    // No project picker any more.
    expect(find.text('Project'), findsNothing);
    expect(find.text('Unit 1'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'John Doe');
    await tester.enterText(fields.at(2), 'b1-g-01');
    await run(tester, frames: 16);
    // Unit codes aren't looked up while typing (the check is deprecated).
    expect(api.sent('GET', 'check-unit-availability'), isEmpty);

    // A second unit.
    await tapText(tester, 'Add another unit');
    expect(find.text('Unit 2'), findsOneWidget);
    await tester.enterText(fields.at(3), 't-12-s');
    await tester.enterText(fields.at(4), 'secret123');
    await tester.enterText(fields.at(5), 'secret123');
    await run(tester, frames: 16);

    await tapText(tester, 'Submit registration');

    expect(find.text('Registration received'), findsOneWidget);
    expect(api.last('POST', 'auth/register').json, {
      'registration_token': 'vN3',
      'name': 'John Doe',
      'unit_codes': ['B1-G-01', 'T-12-S'],
      'password': 'secret123',
      'password_confirmation': 'secret123',
      'locale': 'en',
    });
    await tapText(tester, 'Back to sign in');
    expect(find.byType(CountryButton), findsOneWidget);
    await finish(tester);
  });

  testWidgets('an expired registration token restarts at the phone step', (
    tester,
  ) async {
    api.on(
      'POST',
      'auth/register',
      status: 422,
      body: apiError(ApiErrorCodes.registrationTokenInvalid),
    );
    await start(
      tester,
      initial: RoutesName.registerDetailsScreen,
      extra: const RegisterDetailsArgs(
        phone: '+201012345678',
        registrationToken: 'old',
      ),
    );
    await run(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'John Doe');
    await tester.enterText(fields.at(2), 'B1-G-01');
    await tester.enterText(fields.at(3), 'secret123');
    await tester.enterText(fields.at(4), 'secret123');
    await tapText(tester, 'Submit registration');

    expect(find.text('Start by verifying your mobile number'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('the form requires the password and a unique unit code', (
    tester,
  ) async {
    await start(
      tester,
      initial: RoutesName.registerDetailsScreen,
      extra: const RegisterDetailsArgs(
        phone: '+201012345678',
        registrationToken: 'vN3',
      ),
    );
    await run(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'John Doe');
    await tester.enterText(fields.at(2), 'B1-G-01');
    await tapText(tester, 'Add another unit');
    await tester.enterText(fields.at(3), 'b1-g-01');
    await tester.enterText(fields.at(4), 'secret123');
    await tester.enterText(fields.at(5), 'different1');
    await tapText(tester, 'Submit registration');

    expect(find.text('You already added this unit code.'), findsOneWidget);
    expect(find.text('Passwords Do not Match'), findsOneWidget);
    expect(api.sent('POST', 'auth/register'), isEmpty);

    // Removing the duplicate row clears its error.
    await tapText(tester, 'Remove unit');
    expect(find.text('Unit 2'), findsNothing);
    expect(find.text('You already added this unit code.'), findsNothing);
    await finish(tester);
  });

  testWidgets('screens opened without their arguments go to login', (
    tester,
  ) async {
    await start(tester, initial: RoutesName.setPasswordScreen);
    await run(tester);
    expect(find.byType(CountryButton), findsOneWidget);
    expect(api.requests, isEmpty);
    await finish(tester);
  });

  testWidgets('login screen in Arabic', (tester) async {
    await start(tester, locale: const Locale('ar'));
    await run(tester);

    expect(find.text('ساكن'), findsOneWidget);
    expect(find.text('فريق الأمن'), findsOneWidget);
    expect(find.text('الدخول برمز SMS'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsWidgets);
    await finish(tester);
  });

  group('phone numbers screen', () {
    Map<String, dynamic> phones() => {
      'phones': [
        {
          'id': 3,
          'phone': '+201012345678',
          'is_primary': true,
          'verified': true,
        },
        {
          'id': 5,
          'phone': '+201112345678',
          'is_primary': false,
          'verified': false,
        },
      ],
      'requests': [
        {
          'id': 7,
          'type': 'add',
          'status': 'pending',
          'new_phone': '+201512345678',
          'created_at': '2026-09-19T10:00:00.000000Z',
        },
        {
          'id': 6,
          'type': 'remove',
          'status': 'rejected',
          'old_phone': '+201212345678',
          'rejection_reason': 'Needs the contract',
          'created_at': '2026-09-18T10:00:00.000000Z',
        },
      ],
      'max_pending_requests': 3,
    };

    testWidgets('lists numbers and requests; cancels a request', (
      tester,
    ) async {
      await signedIn(tester);
      api.on('GET', 'profile/phones', body: apiOk(phones()));
      api.on(
        'DELETE',
        'profile/phone-requests/7',
        body: apiOk({'id': 7, 'type': 'add', 'status': 'cancelled'}),
      );
      await start(tester, initial: RoutesName.phoneNumbersScreen);
      await run(tester);

      expect(find.text('+20 10 12345678'), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Not used to sign in yet'), findsOneWidget);
      expect(find.text('Reason: Needs the contract'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);

      await tapText(tester, 'Cancel request');
      await tapText(tester, 'Confirm');

      expect(api.sent('DELETE', 'profile/phone-requests/7'), hasLength(1));
      expect(api.sent('GET', 'profile/phones'), hasLength(2));
      await finish(tester);
    });

    testWidgets('add a number: code to the new number, then request', (
      tester,
    ) async {
      await signedIn(tester);
      api.on('GET', 'profile/phones', body: apiOk(phones()));
      api.on('POST', 'profile/phones/otp', body: apiOk({'resend_in': 60}));
      api.on(
        'POST',
        'profile/phone-requests',
        status: 201,
        body: apiOk({'id': 9, 'type': 'add', 'status': 'pending'}),
      );
      await start(tester, initial: RoutesName.phoneNumbersScreen);
      await run(tester);

      // "Add number" is also the title of the pending add request.
      await tester.tap(find.widgetWithText(CustomButton, 'Add number'));
      await run(tester);
      await typePhone(tester, '1512345678');
      await tapText(tester, 'Send code');
      expect(api.last('POST', 'profile/phones/otp').json, {
        'phone': '+201512345678',
      });

      await typeCode(tester, '123456');

      expect(api.last('POST', 'profile/phone-requests').json, {
        'type': 'add',
        'phone': '+201512345678',
        'code': '123456',
      });
      // The sheet closed and the list reloaded.
      expect(find.byType(PinCodeTextField), findsNothing);
      expect(api.sent('GET', 'profile/phones'), hasLength(2));
      await finish(tester);
    });
  });
}
