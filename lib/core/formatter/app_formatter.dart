import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppFormatter {
  static DateFormat dateFormatter() {
    return DateFormat('yyyy-MM-dd');
  }

  static DateFormat unitEventFormatterForSendRequest() {
    return DateFormat('YYYY-MM-DD');
  }

  static DateFormat unitEventDateFormatter() {
    return DateFormat('MMMM d, yyyy');
  }

  static String formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
 static String formatUtcTime(TimeOfDay time) {
    final now = DateTime.now();
    final localDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final utcDateTime = localDateTime.toUtc();
    return "${utcDateTime.hour.toString().padLeft(2, '0')}:${utcDateTime.minute.toString().padLeft(2, '0')}";
  }
}
