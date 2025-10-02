import 'package:diyar_app/core/constants/app_constants.dart';

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
}
