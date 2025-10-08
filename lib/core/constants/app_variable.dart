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
