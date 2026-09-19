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

  static Future<String?> _firebaseToken() =>
      FirebaseMessaging.instance.getToken();
}
