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

/// Receives FCM messages and turns them into notifications the user can tap.
///
/// Who draws the notification depends on the payload and the app state:
///
/// * **Payload has a `notification` block, app backgrounded or terminated** —
///   the OS draws it (APNs on iOS, `FirebaseMessagingService` on Android).
///   We must *not* draw a second one; see
///   [showLocalNotificationFromBackground].
/// * **Payload has a `notification` block, app in the foreground** — neither
///   platform shows it, so [showLocalNotification] draws it.
/// * **Data-only payload** — nothing is drawn for us in any state, so we draw
///   it ourselves in both handlers.
///
/// A `notification` block is what makes delivery reliable on iOS (data-only
/// pushes need `content-available` and are throttled, and never arrive at all
/// once the user force-quits), so the backend should keep sending one. Routing
/// always reads the `data` block: `type`, `entity_type`, `entity_id`.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Must match `default_notification_channel_id` in AndroidManifest.xml, so
  /// the notifications FCM posts on its own land on this channel too.
  static const String _channelId = 'channel_id';
  static const String _channelName = 'App Notifications';
  static const String _channelDescription = 'Channel for general notifications';

  bool _localNotificationsReady = false;

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

  /// Just enough to call [FlutterLocalNotificationsPlugin.show]. The FCM
  /// background handler runs in its own isolate, where the stream listeners
  /// and navigation that [init] sets up have nothing to attach to.
  Future<void> initLocalNotifications() async {
    if (_localNotificationsReady) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('notification_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Android 8+ ignores the importance passed to `show()` for a channel that
    // already exists, and FCM creates this channel itself the first time it
    // posts. Create it up front so it is high-importance either way.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.max,
          ),
        );

    _localNotificationsReady = true;
  }

  Future<void> init() async {
    await initLocalNotifications();

    // The OS draws background/terminated notifications; showing the remote one
    // in the foreground too would duplicate the local one we draw there.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: true,
          sound: false,
        );

    FirebaseMessaging.onMessage.listen(showLocalNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification opened (onMessageOpenedApp): ${message.data}");
      handleNotificationNavigation(message.data);
    });

    await _handleLaunchNotification();
  }

  /// The app was launched by tapping a notification, so nothing was listening
  /// when the tap happened.
  ///
  /// Two different sources, and only one of them can have fired: the OS-drawn
  /// notification comes back through [FirebaseMessaging.getInitialMessage],
  /// while one we drew ourselves (a data-only push handled in the background)
  /// comes back through the local-notifications plugin.
  Future<void> _handleLaunchNotification() async {
    final launchDetails = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;
    if (launchDetails?.didNotificationLaunchApp == true && response != null) {
      log(
        "App opened from terminated state via local notification: "
        "${response.payload}",
      );
      handleNotificationNavigation(_decodePayload(response.payload));
      return;
    }

    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      log("App opened from terminated state via notification: ${message.data}");
      handleNotificationNavigation(message.data);
    }
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

  /// A message in the foreground: neither platform displays it for us, so we
  /// always draw it (and refresh the screens it affects).
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

    log("Notification received data: ${message.data}");
    await _show(message);
  }

  /// A message that arrived while the app was backgrounded or terminated,
  /// handled in the background isolate.
  ///
  /// When the payload carries a `notification` block the OS has already put a
  /// notification in the tray — APNs on iOS, `FirebaseMessagingService` on
  /// Android — and drawing ours on top of it shows the user the same thing
  /// twice. Only data-only payloads are ours to draw.
  @pragma('vm:entry-point')
  Future<void> showLocalNotificationFromBackground(
    RemoteMessage message,
  ) async {
    if (!enableNotifications) return;
    if (message.notification != null) {
      log('Background message already shown by the OS; not duplicating it.');
      return;
    }
    await _show(message);
  }

  Future<void> _show(RemoteMessage message) async {
    await initLocalNotifications();

    final messageData = MessageData.fromJson(message.data);

    final String localizedTitle = await _getLocalizedText(
      data: message.data,
      enKey: 'title',
      arKey: 'title_ar',
    );
    final String localizedBody = await _getLocalizedText(
      data: message.data,
      enKey: 'body',
      arKey: 'body_ar',
    );

    final String title = localizedTitle.isNotEmpty
        ? localizedTitle
        : messageData.title ?? message.notification?.title ?? 'Notification';
    final String body = localizedBody.isNotEmpty
        ? localizedBody
        : messageData.message ??
              message.notification?.body ??
              'No description available.';

    final String? imageUrl =
        message.data['imageUrl'] ?? message.notification?.android?.imageUrl;
    final String? imagePath = (imageUrl != null && imageUrl.isNotEmpty)
        ? await downloadAndSaveImage(imageUrl)
        : null;

    final androidDetails = AndroidNotificationDetails(
      color: AppColors.whiteColor,
      colorized: true,
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notification_icon',
      styleInformation: imagePath == null
          ? null
          : BigPictureStyleInformation(
              FilePathAndroidBitmap(imagePath),
              contentTitle: title,
              summaryText: body,
              htmlFormatContent: true,
              htmlFormatContentTitle: true,
            ),
    );

    // iOS 14+ reads `presentBanner`/`presentList` and ignores `presentAlert`,
    // which is only consulted on iOS 13 and older. Set all three or the
    // notification is delivered silently to the notification centre.
    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentBadge: true,
      presentSound: true,
      attachments: imagePath == null
          ? null
          : [DarwinNotificationAttachment(imagePath)],
    );

    await flutterLocalNotificationsPlugin.show(
      _notificationId(message),
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: darwinDetails),
      payload: _encodePayload(message.data),
    );
  }

  /// Android rejects a notification id outside a signed 32-bit int, and
  /// `Map` doesn't override `hashCode`, so the raw value is an identity hash
  /// that changes per isolate. Derive a stable id from the routing keys so the
  /// same notification arriving twice replaces itself instead of stacking.
  static int _notificationId(RemoteMessage message) {
    final key =
        message.messageId ??
        '${message.data['type']}:${message.data['entity_type']}:'
            '${message.data['entity_id']}:${message.data['title']}';
    return key.hashCode & 0x7fffffff;
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

  /// Caches the notification image, or returns null when it can't be fetched.
  /// A throw here would take the whole notification down with it.
  Future<String?> downloadAndSaveImage(String url) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = url.hashCode.toString();
      final String filePath = '${tempDir.path}/$fileName.jpg';

      final file = File(filePath);
      if (await file.exists()) return filePath;

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        log('Notification image $url returned ${response.statusCode}');
        return null;
      }
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      log('Could not download the notification image $url: $e');
      return null;
    }
  }
}
