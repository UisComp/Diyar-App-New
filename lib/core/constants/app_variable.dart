import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';

LoginResponseModel? userModel;
Future<void> updateUserModel(LoginResponseModel? user) async {
  userModel = user;
}

String? savedEmail;
Future<void> saveEmail(String? email) async {
  savedEmail = email;
  await HiveHelper.addToHive(key: AppConstants.emailKey, value: savedEmail);
}
