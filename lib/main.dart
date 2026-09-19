import 'dart:io';
import 'package:diyar_app/bloc_observer.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart' hide navigatorKey;
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
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
  // 1. Initialize Firebase FIRST
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await HiveHelper.init();
  bool enable =
      await HiveHelper.getFromHive(key: AppConstants.enableNotification) ??
      true;
  if (!enable) return;
  final service = NotificationService();
  await service.init();
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
  try {
    fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await HiveHelper.addToHive(key: AppConstants.fcmToken, value: fcmToken!);
      AppLogger.log("FCM Token saved: $fcmToken");
    }
  } catch (ex) {
    AppLogger.log("exception on fcm init ${ex.toString()}");
  }

  // Each login is a device; when Firebase rotates this device's token,
  // replace it on the account.
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    fcmToken = token;
    await HiveHelper.addToHive(key: AppConstants.fcmToken, value: token);
    await AuthSession.onPushTokenRefreshed(token);
  }, onError: (e) => AppLogger.log("onTokenRefresh error: $e"));

  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    AppLogger.log("apnsToken: $apnsToken");
  }

  // The backend team needs this hash for SMS code autofill on Android.
  if (kDebugMode) unawaited(SmsCodeRetriever.logAppSignature());

  final NotificationService localNotificationService = NotificationService();
  await localNotificationService.init();
}
