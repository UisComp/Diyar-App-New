// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();

//   factory NotificationService() => _instance;

//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('notification_icon');
//     const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      
//     );

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
//     BigPictureStyleInformation? bigPictureStyleInformation;
// Future<void> showLocalNotification(RemoteMessage message) async {
//   final messageData = MessageData.fromJson(message.data);
//   log("Notification received: ${message.data}");

//   BigPictureStyleInformation? bigPictureStyleInformation;

//   String? imageUrl = message.data['imageUrl'];
//   if (imageUrl != null && imageUrl.isNotEmpty) {
//     final imagePath = await downloadAndSaveImage(imageUrl);
//     bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(imagePath),
//       contentTitle: message.notification?.title ?? 'New Notification',
//       summaryText: message.notification?.body ?? '',
//       htmlFormatContent: true,
//       htmlFormatContentTitle: true,
//     );
//   }

//   final androidDetails = AndroidNotificationDetails(
//     'channel_id',
//     'App Notifications',
//     channelDescription: 'Channel for general notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: 'notification_icon',
//     styleInformation: bigPictureStyleInformation,
//   );

//   final notificationDetails = NotificationDetails(android: androidDetails);
//   await flutterLocalNotificationsPlugin.show(
//     message.data.hashCode,
//     messageData.title ?? 'Notification Title',
//     messageData.message ?? 'No description available.',
//     notificationDetails,
//     payload: messageData.type,
//   );
// }

// @pragma('vm:entry-point')
// Future<void> showLocalNotificationFromBackground(RemoteMessage message) async {
//   final messageData = MessageData.fromJson(message.data);

//   BigPictureStyleInformation? bigPictureStyleInformation;

//   String? imageUrl = message.data['imageUrl'];
//   if (imageUrl != null && imageUrl.isNotEmpty) {
//     final imagePath = await downloadAndSaveImage(imageUrl);
//     bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(imagePath),
//       contentTitle: message.notification?.title ?? 'New Notification',
//       summaryText: message.notification?.body ?? '',
//       htmlFormatContent: true,
//       htmlFormatContentTitle: true,
//     );
//   }

//   final androidDetails = AndroidNotificationDetails(
//     'channel_id',
//     'Background Notifications',
//     channelDescription: 'Notifications received in background',
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: 'notification_icon',
//     styleInformation: bigPictureStyleInformation,
//   );

//   final platformDetails = NotificationDetails(android: androidDetails);
//   await flutterLocalNotificationsPlugin.show(
//     message.data.hashCode,
//     messageData.title ?? 'Notification Title',
//     messageData.message ?? 'No description available.',
//     platformDetails,
//     payload: messageData.type,
//   );
// }
//   void onSelectNotification(NotificationResponse response) {
//     final type = response.payload;
//     log('Notification tapped with type: $type');
//     log('Notification tapped : ${response}');

//     if (type == 'personal') {
//       navigatorKey.currentState?.pushNamed(
//           Routes.NOTIFICATION);
//     }
//   }
//     Future<String> downloadAndSaveImage(String url) async {
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