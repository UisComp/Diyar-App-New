import 'dart:io';

import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// What the backend needs to register this device for pushes: every login
/// sends `fcm_token` and `platform`.
abstract class DeviceHelper {
  /// `"ios"` or `"android"`.
  static String get platform => Platform.isIOS ? 'ios' : 'android';

  /// Reads the current Firebase token. Replaceable in tests.
  static Future<String?> Function() tokenReader = _firebaseToken;

  /// The push token, or null if Firebase can't give one right now (no
  /// network, no APNs token yet). A login never fails because of it.
  static Future<String?> pushToken() async {
    try {
      return await tokenReader();
    } catch (e) {
      AppLogger.warning('Could not read the FCM token: $e');
      return null;
    }
  }

  /// On iOS, Firebase refuses to mint an FCM token until APNs has handed it a
  /// device token, and `getToken()` throws `apns-token-not-set` instead of
  /// waiting. APNs registration is asynchronous and usually lands within a
  /// second of launch, so poll for it before asking for the FCM token —
  /// otherwise a login that happens early registers no token at all and the
  /// device silently never receives a push.
  ///
  /// Returns null if APNs never answers (no network, simulator, notifications
  /// denied); callers treat that as "no token yet".
  static Future<String?> awaitApnsToken({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!Platform.isIOS) return null;
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      try {
        final token = await FirebaseMessaging.instance.getAPNSToken();
        if (token != null) return token;
      } catch (e) {
        AppLogger.warning('Could not read the APNs token: $e');
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    AppLogger.warning('APNs token was not available within $timeout');
    return null;
  }

  static Future<String?> _firebaseToken() async {
    if (Platform.isIOS) await awaitApnsToken();
    return FirebaseMessaging.instance.getToken();
  }
}
