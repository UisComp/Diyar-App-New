import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final navigatorKey = GlobalKey<NavigatorState>();
LoginResponseModel? userModel;
Future<void> updateUserModel(LoginResponseModel? user) async {
  userModel = user;
}

String? savedEmailForForgetPasword;
Future<void> saveEmail(String? email) async {
  savedEmailForForgetPasword = email;
  await HiveHelper.addToHive(
    key: AppConstants.emailKey,
    value: savedEmailForForgetPasword,
  );
}

String? savedRefreshToken;
Future<void> saveRefreshToken(String? token) async {
  savedRefreshToken = token;
  await HiveHelper.addToHive(
    key: AppConstants.refreshTokenKey,
    value: savedRefreshToken,
  );
}

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
String? savedEmailForLoginWithBioMetric;
String? savedPasswordForLoginWithBioMetric;
Future<void> savedCredentials({required String email, String? password}) async {
  savedEmailForLoginWithBioMetric = email;
  await HiveHelper.addToHive(key: AppConstants.myEmail, value: email);
  savedPasswordForLoginWithBioMetric = password;
  if (password != null) {
    await secureStorage.write(key: AppConstants.myPassword, value: password);
  }
}

bool? enableBiometric;
Future<void> saveBiometricStatus(bool isEnabled) async {
  if (!isEnabled) {
    enableBiometric = false;
    await HiveHelper.addToHive(key: AppConstants.enableBiometric, value: false);
    return;
  }
  enableBiometric = true;
  await HiveHelper.addToHive(key: AppConstants.enableBiometric, value: true);
}
  String getTranslatedStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return LocaleKeys.completed.tr(); // مكتمل
      case 'pending':
        return LocaleKeys.pending.tr(); //  الانتظار
      case 'cancelled':
        return LocaleKeys.cancelled.tr(); 
      case 'confirmed':
        return LocaleKeys.confirmed.tr();  
      default:
        return status?.toUpperCase() ?? '';
    }
  }
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'confirmed':
        return Colors.blue;  
      default:
        return Colors.grey;
    }
  }
   IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      case 'confirmed':
        return Icons.check_circle_outline;  
      default:
        return Icons.help_outline;
    }
  }