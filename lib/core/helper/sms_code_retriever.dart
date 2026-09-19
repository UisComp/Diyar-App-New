import 'dart:io';

import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:smart_auth/smart_auth.dart';

/// Reads the login code from the SMS on Android (SMS Retriever API), without
/// the SMS permission. The backend adds the app's hash at the end of the SMS
/// (`SMS_ANDROID_APP_HASH`); see [logAppSignature].
///
/// iOS needs nothing here: the code field is marked `oneTimeCode`, so the
/// keyboard offers the code.
abstract class SmsCodeRetriever {
  /// Waits for the next code SMS; null if none arrives (about 5 minutes) or
  /// on other platforms. Replaceable in tests.
  static Future<String?> Function() listen = _listen;

  /// Stops waiting. Replaceable in tests.
  static Future<void> Function() stop = _stop;

  static Future<String?> _listen() async {
    if (!Platform.isAndroid) return null;
    final result = await SmartAuth.instance.getSmsWithRetrieverApi(
      matcher: r'\d{6}',
    );
    return result.data?.code;
  }

  static Future<void> _stop() async {
    if (!Platform.isAndroid) return;
    await SmartAuth.instance.removeSmsRetrieverApiListener();
  }

  /// Logs the 11-character hash for this build's signing key. Send it to
  /// the backend team: debug and release keys have different hashes.
  static Future<void> logAppSignature() async {
    if (!Platform.isAndroid) return;
    final result = await SmartAuth.instance.getAppSignature();
    AppLogger.info('SMS Retriever app hash: ${result.data}');
  }
}
