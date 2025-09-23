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
  }) {
    if (password == null || password.isEmpty) {
      return emptyMessage;
    }
    if (password.contains(' ')) {
      return spaceMessage;
    }
    return null;
  }
}
