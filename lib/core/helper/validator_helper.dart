import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ValidatorHelper {
  static String? validateEmail(
    String? email, {
    required String emptyMessage,
    required String invalidMessage,
  }) {
    if (email == null || email.isEmpty) {
      return emptyMessage;
    }
    if (!RegExp(AppConstants.emailPattern).hasMatch(email)) {
      return invalidMessage;
    }
    return null;
  }

  static String? validatePhoneOrPassword(
    String? password, {
    required String emptyMessage,
    required String spaceMessage,
    String? minLengthMessage,
    int minLength = 8,
  }) {
    if (password == null || password.isEmpty) {
      return emptyMessage;
    }
    if (password.contains(' ')) {
      return spaceMessage;
    }
    if (password.length < minLength) {
      return minLengthMessage;
    }
    return null;
  }

  static String? validatePasswordConfirmation(
    String? confirmPassword, {
    required String originalPassword,
    required String emptyMessage,
    required String notMatchMessage,
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return emptyMessage;
    }
    if (confirmPassword != originalPassword) {
      return notMatchMessage;
    }
    return null;
  }

  static bool isPast(TimeOfDay time) {
    final now = TimeOfDay.now();
    return time.hour * 60 + time.minute < now.hour * 60 + now.minute;
  }

  // static bool isAfter(TimeOfDay a, TimeOfDay b) {
  //   return a.hour * 60 + a.minute > b.hour * 60 + b.minute;
  // }
  static bool isPastDateTime(DateTime startDate, TimeOfDay startTime) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    return selectedDateTime.isBefore(now);
  }

  static bool isAfter(DateTime startDate, TimeOfDay startTime, TimeOfDay endTime) {
    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      endTime.hour,
      endTime.minute,
    );
    return endDateTime.isAfter(startDateTime);
  }
}
