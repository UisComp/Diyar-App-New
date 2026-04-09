import 'dart:developer';
import 'dart:io';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/routes/app_routes.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
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
      final messageData = MessageData.fromJson(message.data);
      handleNotificationNavigation(messageData.type);
    });

    // Handle initial message when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        log(
          "App opened from terminated state via notification: ${message.data}",
        );
        final messageData = MessageData.fromJson(message.data);
        handleNotificationNavigation(messageData.type);
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
      payload: messageData.type,
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
      payload: messageData.type,
    );
  }

  void onSelectNotification(NotificationResponse response) {
    final type = response.payload;
    log('Notification tapped with type: $type');
    handleNotificationNavigation(type);
  }

  void handleNotificationNavigation(String? type) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        try {
          NotificationController.get(
            context,
          ).fetchAllNotifications(refresh: true, page: 1);
        } catch (e) {
          log('Error refreshing notifications: $e');
        }
        if (type == 'overdue') {
          HomeController.get(context).changeIndexBottomNavBar(3);
          router.go(RoutesName.homeLayout);
        } else {
          router.push(RoutesName.notificationsScreen);
        }
      }
    });
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
