import 'dart:io';
import 'package:diyar_app/bloc_observer.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart' hide navigatorKey;
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/helper/notification_helper.dart';
import 'package:diyar_app/core/helper/sms_code_retriever.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/internet/controller/internet_controller.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/firebase_options.dart';
import 'package:diyar_app/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in its own isolate with none of `main`'s setup, so Firebase and Hive
  // have to be started again here.
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await HiveHelper.init();
  enableNotifications =
      await HiveHelper.getFromHive(key: AppConstants.enableNotification) ??
      true;
  if (!enableNotifications) return;
  final service = NotificationService();
  // Only the local-notifications plugin: the FCM listeners and the navigation
  // `init` wires up belong to the UI isolate and would leak here.
  await service.initLocalNotifications();
  await service.showLocalNotificationFromBackground(message);
  AppLogger.log('Background message handled: ${message.messageId}');
}

bool enableNotifications = true;
Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        // DeviceOrientation.portraitDown, // Optional: allow upside-down portrait
      ]);
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      FlutterError.onError = (FlutterErrorDetails details) {
        if (_isHarmlessWebViewTeardownAssert(details.exception)) {
          AppLogger.warning(
            'Ignored WebView teardown message: ${details.exception}',
          );
          return;
        }
        FlutterError.presentError(details);
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await ScreenUtil.ensureScreenSize();
      await EasyLocalization.ensureInitialized();
      await HiveHelper.init();
      await DioHelper.init();
      DioHelper.onSessionExpired = AuthSession.expire;

      Bloc.observer = AppBlocObserver();

      userModel = await HiveHelper.getUserModel(AppConstants.userModelKey);
      enableBiometric = await HiveHelper.getFromHive(
        key: AppConstants.enableBiometric,
      );
      enableNotifications =
          await HiveHelper.getFromHive(key: AppConstants.enableNotification) ??
          true;

      final languageController = await LanguageController.create();
      await NotificationService().setupFirebase();
      await setupNotifications();
      runApp(
        EasyLocalization(
          assetLoader: const CodegenLoader(),
          supportedLocales: AppConstants.supportedLocales,
          path: AppConstants.translationPath,
          fallbackLocale: const Locale(AppConstants.enLanguage),
          startLocale: languageController.getLocaleFromMode(),
          saveLocale: true,
          // Apply each language's plural rules (Arabic has few/many forms).
          ignorePluralRules: false,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => InternetConnectionController()),
              BlocProvider<LanguageController>.value(value: languageController),
              BlocProvider(create: (_) => AppThemeController()),
              BlocProvider(create: (_) => ProfileController()),
              BlocProvider(create: (_) => NotificationController()),
              BlocProvider(
                create: (_) => SettingsController()..getConfigData(),
              ),
              BlocProvider(create: (_) => HomeController()),
            ],
            child: const DiyarApp(),
          ),
        ),
      );

      FlutterNativeSplash.remove();
    },
    (error, stackTrace) {
      if (_isHarmlessWebViewTeardownAssert(error)) {
        AppLogger.warning("Ignored WebView teardown message: $error");
        return;
      }
      AppLogger.error("Caught by runZonedGuarded: $error");
      AppLogger.error(stackTrace.toString());
    },
  );
}

/// A JavaScript message that lands after its WKWebView is gone, which
/// webview_flutter_wkwebview reports as a failed assertion.
///
/// It happens while a video player is being disposed: the message is dropped
/// and nothing else breaks, and the assert is compiled out of release builds.
/// Not fixed upstream in any version this Flutter SDK can resolve, so it is
/// logged as a warning instead of a crash.
bool _isHarmlessWebViewTeardownAssert(Object error) {
  final text = error.toString();
  return text.contains('didReceiveScriptMessage') &&
      text.contains('WKUserContentController');
}

String? fcmToken;
Future<void> setupNotifications() async {
  // Each login is a device; when Firebase rotates this device's token,
  // replace it on the account.
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    fcmToken = token;
    await HiveHelper.addToHive(key: AppConstants.fcmToken, value: token);
    await AuthSession.onPushTokenRefreshed(token);
  }, onError: (e) => AppLogger.log("onTokenRefresh error: $e"));

  // The backend team needs this hash for SMS code autofill on Android.
  if (kDebugMode) unawaited(SmsCodeRetriever.logAppSignature());

  // Handlers first: a tap that launched the app is waiting to be read, and
  // reading the token can block for seconds on iOS.
  await NotificationService().init();
  unawaited(_registerPushToken());
}

/// Reads this device's push token and makes sure the account carries it.
///
/// On iOS this waits for APNs to register, which can take a moment after
/// launch, so it runs off the startup path rather than holding up the first
/// frame.
Future<void> _registerPushToken() async {
  try {
    if (Platform.isIOS) {
      AppLogger.log("apnsToken: ${await DeviceHelper.awaitApnsToken()}");
    }
    fcmToken = await DeviceHelper.pushToken();
    if (fcmToken == null) {
      AppLogger.warning("No FCM token yet; this device won't receive pushes.");
      return;
    }
    await HiveHelper.addToHive(key: AppConstants.fcmToken, value: fcmToken!);
    AppLogger.log("FCM Token saved: $fcmToken");
    // A login that ran before APNs was ready sent no token at all, and the
    // token never rotates again on its own.
    await AuthSession.ensurePushTokenRegistered(fcmToken);
  } catch (ex) {
    AppLogger.log("exception on fcm init ${ex.toString()}");
  }
}
