import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';

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

String? savedEmailForLoginWithBioMetric;
String? savedPasswordForLoginWithBioMetric;
Future<void> savedCredentials({
  required String email,
   String ?password,
}) async {
  savedEmailForLoginWithBioMetric = email;
  await HiveHelper.addToHive(key: AppConstants.myEmail, value: email);
  savedPasswordForLoginWithBioMetric = password;

  await HiveHelper.addToHive(key: AppConstants.myPassword, value: password);
}

bool? enableBiometric;
Future<void> saveBiometricStatus(bool isEnabled) async {
  if (!isEnabled) {
    enableBiometric = false;
    await HiveHelper.addToHive(
      key: AppConstants.enableBiometric,
      value: false,
    );
    return;
  }
  enableBiometric = true;
  await HiveHelper.addToHive(
    key: AppConstants.enableBiometric,
    value: true,
  );
}
