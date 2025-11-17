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
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:diyar_app/feature/internet/controller/internet_controller.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/firebase_options.dart';
import 'package:diyar_app/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await navigatorKey.currentContext
      ?.read<NotificationController>()
      .fetchAllNotifications(page: 1, refresh: true);
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await NotificationService().init();
  AppLogger.log('Handling a background message: ${message.messageId}');
  await NotificationService().showLocalNotificationFromBackground(message);
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      FlutterError.onError = (FlutterErrorDetails details) {
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

      Bloc.observer = AppBlocObserver();

      userModel = await HiveHelper.getUserModel(AppConstants.userModelKey);
      enableBiometric = await HiveHelper.getFromHive(
        key: AppConstants.enableBiometric,
      );
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
            ],
            child: const DiyarApp(),
          ),
        ),
      );

      FlutterNativeSplash.remove();
    },
    (error, stackTrace) {
      AppLogger.error("Caught by runZonedGuarded: $error");
      AppLogger.error(stackTrace.toString());
    },
  );
}

// Future<void> main() async {
//   final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await ScreenUtil.ensureScreenSize();
//   await EasyLocalization.ensureInitialized();
//   await HiveHelper.init();
//   await DioHelper.init();
//   Bloc.observer = AppBlocObserver();
//   userModel = await HiveHelper.getUserModel(AppConstants.userModelKey);
//   enableBiometric = await HiveHelper.getFromHive(
//     key: AppConstants.enableBiometric,
//   );
//   final languageController = await LanguageController.create();
//   await setupFirebase();
//   await setupNotifications();
//   runApp(
//     EasyLocalization(
//       assetLoader: const CodegenLoader(),
//       supportedLocales: AppConstants.supportedLocales,
//       path: AppConstants.translationPath,
//       fallbackLocale: const Locale(AppConstants.enLanguage),
//       startLocale: languageController.getLocaleFromMode(),
//       saveLocale: true,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => InternetConnectionController()),
//           BlocProvider<LanguageController>.value(value: languageController),
//           BlocProvider(create: (_) => AppThemeController()),
//           BlocProvider(create: (_) => ProfileController()),
//           BlocProvider(create: (_) => NotificationController()),
//           BlocProvider(create: (_) => SettingsController()..getConfigData()),
//         ],
//         child: const DiyarApp(),
//       ),
//     ),
//   );
//   FlutterNativeSplash.remove();
// }

String? fcmToken;
Future<void> setupNotifications() async {
  try {
    fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await HiveHelper.addToHive(key: AppConstants.fcmToken, value: fcmToken!);
      AppLogger.log("FCM Token saved: $fcmToken");
    }
    AppLogger.log("FCM Token: $fcmToken");
  } catch (ex) {
    AppLogger.log("exception on fcm init ${ex.toString()}");
  }
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    AppLogger.log("apnsToken: $apnsToken");
  }
  final NotificationService localNotificationService = NotificationService();

  FirebaseMessaging.onMessage.listen((message) async {
    AppLogger.log("Foreground message received data: $message");

    await localNotificationService.showLocalNotification(message);
    navigatorKey.currentContext
        ?.read<NotificationController>()
        .fetchAllNotifications(page: 1, refresh: true);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    navigatorKey.currentContext
        ?.read<NotificationController>()
        .fetchAllNotifications(page: 1, refresh: true);
    AppLogger.log("Notification opened: ${message.data}");
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await localNotificationService.init();
}
