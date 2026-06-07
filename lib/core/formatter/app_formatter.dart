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

  /// Short month label used by the project timeline month strip (e.g. "Jan").
  static DateFormat monthShortFormatter() {
    return DateFormat('MMM');
  }

  /// Month + year label used to summarize the selected timeline range
  /// (e.g. "Jan 2026").
  static DateFormat monthYearFormatter() {
    return DateFormat('MMM yyyy');
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

  static String formatDate(DateTime date) =>
      DateFormat('MMM d, yyyy • h:mm a').format(date);

  /// Time only, used by notification rows whose day is shown in the group
  /// header (e.g. "3:44 PM").
  static String formatTimeOnly(DateTime date) =>
      DateFormat('h:mm a').format(date);

  /// Day label for a notification group header that isn't Today/Yesterday
  /// (e.g. "Apr 9, 2026").
  static String formatDayLabel(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date);

  static String formatDateWithTime(DateTime date) =>
      DateFormat('yyyy/MM/dd  HH:mm').format(date);
}
