import 'dart:developer' as developer;
import 'package:flutter/foundation.dart'; 

class AppLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      _log(_cyan, message, tag ?? 'INFO');
    }
  }

  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      _log(_green, message, tag ?? 'SUCCESS');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      _log(_yellow, message, tag ?? 'WARNING');
    }
  }

  static void error(String message,
      {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      var msg = message;
      if (error != null) msg += '\nError: $error';
      if (stackTrace != null) msg += '\nStackTrace: $stackTrace';
      _log(_red, msg, tag ?? 'ERROR');
    }
  }

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      _log(_white, message, tag ?? 'LOG');
    }
  }

  static void _log(String color, String message, String tag) {
    developer.log(
      '$color$message$_reset',
      name: tag,
    );
  }
}
