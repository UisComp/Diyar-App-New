import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/routes/app_routes.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/finance/controller/finance_refresh_notifier.dart';
import 'package:diyar_app/feature/finance/view/finance_screen.dart'
    show canAccessFinance;
import 'package:diyar_app/feature/finance/view/unit_payment_plan_screen.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:diyar_app/feature/notifications/helper/notification_routing.dart';
import 'package:diyar_app/feature/notifications/model/message_data_response_model.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/firebase_options.dart';
import 'package:diyar_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('notification_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    FirebaseMessaging.onMessage.listen(showLocalNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification opened (onMessageOpenedApp): ${message.data}");
      handleNotificationNavigation(message.data);
    });

    // Handle initial message when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        log(
          "App opened from terminated state via notification: ${message.data}",
        );
        handleNotificationNavigation(message.data);
      }
    });
  }

  Future<String> _getLocalizedText({
    required Map<String, dynamic> data,
    required String enKey,
    required String arKey,
  }) async {
    final String? savedLocale = await HiveHelper.getFromHive(
      key: AppConstants.myCurrentLanguagekey,
    );
    final bool isArabic = savedLocale == 'ar';

    if (isArabic) {
      return data[arKey] ?? data[enKey] ?? '';
    }
    return data[enKey] ?? data[arKey] ?? '';
  }

  BigPictureStyleInformation? bigPictureStyleInformation;

  Future<void> showLocalNotification(RemoteMessage message) async {
    if (NotificationRouting.isFinancial(
      type: message.data['type']?.toString(),
      entityType: message.data['entity_type']?.toString(),
    )) {
      FinanceRefreshNotifier.instance.requestRefresh();
    }
    if (!enableNotifications) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        try {
          NotificationController.get(
            context,
          ).fetchAllNotifications(refresh: true, page: 1);
        } catch (e) {
          log('Error refreshing notifications in foreground: $e');
        }
      }
    });

    final messageData = MessageData.fromJson(message.data);
    log("Notification received data: ${message.data}");

    final String title = await _getLocalizedText(
      data: message.data,
      enKey: 'title',
      arKey: 'title_ar',
    );

    final String body = await _getLocalizedText(
      data: message.data,
      enKey: 'body',
      arKey: 'body_ar',
    );

    BigPictureStyleInformation? bigPictureStyleInformation;
    String? imageUrl = message.data['imageUrl'];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final imagePath = await downloadAndSaveImage(imageUrl);
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
        contentTitle: title.isNotEmpty
            ? title
            : message.notification?.title ?? 'New Notification',
        summaryText: body.isNotEmpty ? body : message.notification?.body ?? '',
        htmlFormatContent: true,
        htmlFormatContentTitle: true,
      );
    }

    final androidDetails = AndroidNotificationDetails(
      color: AppColors.whiteColor,
      colorized: true,
      'channel_id',
      'App Notifications',
      channelDescription: 'Channel for general notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notification_icon',
      styleInformation: bigPictureStyleInformation,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      title.isNotEmpty ? title : messageData.title ?? 'Notification Title',
      body.isNotEmpty
          ? body
          : messageData.message ?? 'No description available.',
      notificationDetails,
      payload: _encodePayload(message.data),
    );
  }

  @pragma('vm:entry-point')
  Future<void> showLocalNotificationFromBackground(
    RemoteMessage message,
  ) async {
    if (!enableNotifications) return;

    final messageData = MessageData.fromJson(message.data);

    final String title = await _getLocalizedText(
      data: message.data,
      enKey: 'title',
      arKey: 'title_ar',
    );

    final String body = await _getLocalizedText(
      data: message.data,
      enKey: 'body',
      arKey: 'body_ar',
    );

    BigPictureStyleInformation? bigPictureStyleInformation;

    String? imageUrl = message.data['imageUrl'];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final imagePath = await downloadAndSaveImage(imageUrl);
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
        contentTitle: title.isNotEmpty
            ? title
            : message.notification?.title ?? 'New Notification',
        summaryText: body.isNotEmpty ? body : message.notification?.body ?? '',
        htmlFormatContent: true,
        htmlFormatContentTitle: true,
      );
    }

    final androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Background Notifications',
      channelDescription: 'Notifications received in background',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notification_icon',
      styleInformation: bigPictureStyleInformation,
    );

    final platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      title.isNotEmpty ? title : messageData.title ?? 'Notification Title',
      body.isNotEmpty
          ? body
          : messageData.message ?? 'No description available.',
      platformDetails,
      payload: _encodePayload(message.data),
    );
  }

  /// Keeps only the routing keys; FCM data values are all strings.
  static String _encodePayload(Map<String, dynamic> data) => jsonEncode({
    'type': data['type'],
    'entity_type': data['entity_type'],
    'entity_id': data['entity_id'],
  });

  /// Older payloads were the bare `type` string.
  static Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return {};
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {'type': payload};
  }

  void onSelectNotification(NotificationResponse response) {
    log('Notification tapped with payload: ${response.payload}');
    handleNotificationNavigation(_decodePayload(response.payload));
  }

  /// Set when a notification is tapped while the splash is still showing
  /// (cold start). The splash hands off to home and then consumes it, so the
  /// splash navigation doesn't wipe the notification's screen.
  NotificationTarget? _pendingTarget;

  void handleNotificationNavigation(Map<String, dynamic> data) {
    final target = NotificationRouting.pushTarget(data);
    if (target is FinanceTabTarget || target is UnitPaymentPlanTarget) {
      FinanceRefreshNotifier.instance.requestRefresh();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      final location = router.routerDelegate.currentConfiguration.uri.path;
      if (context == null || location == RoutesName.splash) {
        _pendingTarget = target;
        return;
      }
      _navigateTo(context, target);
    });
  }

  /// Called by the splash right after it navigates a signed-in user home.
  void consumePendingNavigation() {
    final target = _pendingTarget;
    _pendingTarget = null;
    if (target == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) _navigateTo(context, target);
    });
  }

  void _navigateTo(BuildContext context, NotificationTarget target) {
    try {
      NotificationController.get(
        context,
      ).fetchAllNotifications(refresh: true, page: 1);
    } catch (e) {
      log('Error refreshing notifications: $e');
    }

    if (target is PhoneNumbersTarget) {
      router.push(
        AuthSession.isResident
            ? RoutesName.phoneNumbersScreen
            : RoutesName.notificationsScreen,
      );
      return;
    }

    if (!canAccessFinance) {
      router.push(RoutesName.notificationsScreen);
      return;
    }

    switch (target) {
      case FinanceTabTarget():
        HomeController.get(context).changeTab(AppTab.finance);
        router.go(RoutesName.homeLayout);
      case UnitPaymentPlanTarget(:final installmentId):
        router.push(
          RoutesName.unitPaymentPlanScreen,
          extra: UnitPaymentPlanArgs(installmentId: installmentId),
        );
      // Phone requests are handled above.
      case NotificationsListTarget():
      case PhoneNumbersTarget():
        router.push(RoutesName.notificationsScreen);
    }
  }

  Future<String> downloadAndSaveImage(String url) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = url.hashCode.toString();
    final String filePath = '${tempDir.path}/$fileName.jpg';

    final file = File(filePath);
    if (await file.exists()) return filePath;

    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

// import 'dart:developer';
// import 'dart:io';
// import 'package:diyar_app/core/constants/app_constants.dart';
// import 'package:diyar_app/core/routes/app_routes.dart';
// import 'package:diyar_app/core/routes/routes_name.dart';
// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:diyar_app/feature/notifications/model/message_data_response_model.dart';
// import 'package:diyar_app/firebase_options.dart';
// import 'package:diyar_app/main.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();

//   factory NotificationService() => _instance;

//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   Future<void> setupFirebase() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }

//   Future<void> init() async {
//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('notification_icon');
//     const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

//     final InitializationSettings initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: onSelectNotification,
//     );
//     FirebaseMessaging.onMessage.listen(showLocalNotification);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("Notification opened (onMessageOpenedApp): ${message.data}");
//     });
//   }

//   BigPictureStyleInformation? bigPictureStyleInformation;
//   Future<void> showLocalNotification(RemoteMessage message) async {
//     if (!enableNotifications) return;

//     final messageData = MessageData.fromJson(message.data);
//     log("Notification received data: ${message.data}");

//     BigPictureStyleInformation? bigPictureStyleInformation;
//     String? imageUrl = message.data['imageUrl'];
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       final imagePath = await downloadAndSaveImage(imageUrl);
//       bigPictureStyleInformation = BigPictureStyleInformation(
//         FilePathAndroidBitmap(imagePath),
//         contentTitle: message.notification?.title ?? 'New Notification',
//         summaryText: message.notification?.body ?? '',
//         htmlFormatContent: true,
//         htmlFormatContentTitle: true,
//       );
//     }

//     final androidDetails = AndroidNotificationDetails(
//       color: AppColors.whiteColor,
//       colorized: true,
//       'channel_id',
//       'App Notifications',
//       channelDescription: 'Channel for general notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: 'notification_icon',
//       styleInformation: bigPictureStyleInformation,
//     );

//     final notificationDetails = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       messageData.title ?? 'Notification Title',
//       messageData.message ?? 'No description available.',
//       notificationDetails,
//       payload: messageData.type,
//     );
//   }

//   @pragma('vm:entry-point')
//   Future<void> showLocalNotificationFromBackground(
//     RemoteMessage message,
//   ) async {
//     if (!enableNotifications) return;
//     final messageData = MessageData.fromJson(message.data);

//     BigPictureStyleInformation? bigPictureStyleInformation;

//     String? imageUrl = message.data['imageUrl'];
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       final imagePath = await downloadAndSaveImage(imageUrl);
//       bigPictureStyleInformation = BigPictureStyleInformation(
//         FilePathAndroidBitmap(imagePath),
//         contentTitle: message.notification?.title ?? 'New Notification',
//         summaryText: message.notification?.body ?? '',
//         htmlFormatContent: true,
//         htmlFormatContentTitle: true,
//       );
//     }

//     final androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'Background Notifications',
//       channelDescription: 'Notifications received in background',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: 'notification_icon',
//       styleInformation: bigPictureStyleInformation,
//     );

//     final platformDetails = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       messageData.title ?? 'Notification Title',
//       messageData.message ?? 'No description available.',
//       platformDetails,
//       payload: messageData.type,
//     );
//   }

//   void onSelectNotification(NotificationResponse response) {
//     final type = response.payload;
//     log('Notification tapped with type: $type');

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final context = navigatorKey.currentContext;
//       if (context != null) {
//         if (type == 'personal') {
//           router.push(RoutesName.notificationsScreen);
//         }
//       }
//     });
//   }

//   Future<String> downloadAndSaveImage(String url) async {
//     final Directory tempDir = await getTemporaryDirectory();
//     final String fileName = url.hashCode.toString();
//     final String filePath = '${tempDir.path}/$fileName.jpg';

//     final file = File(filePath);
//     if (await file.exists()) return filePath;

//     final response = await http.get(Uri.parse(url));
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
// }
