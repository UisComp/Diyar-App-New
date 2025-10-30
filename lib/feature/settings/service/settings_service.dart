import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/settings/model/change_password_request_model.dart';
import 'package:diyar_app/feature/settings/model/change_password_response_model.dart';
import 'package:diyar_app/feature/settings/model/config_data_model.dart';

class SettingsService {
  static Future<ChangePasswordResponseModel> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async {
    final changePasswordResponse = await DioHelper.postData(
      path: ApiPaths.changePassword,
      data: changePasswordRequestModel.toJson(),
    );
    AppLogger.info("changePasswordResponse $changePasswordResponse");
    try {
      if (changePasswordResponse != null &&
          changePasswordResponse.statusCode == 200) {
        return ChangePasswordResponseModel.fromJson(
          changePasswordResponse.data,
        );
      }
    } catch (e) {
      AppLogger.error('Error Happen While Change Password is $e');
    }
    return ChangePasswordResponseModel.fromJson(changePasswordResponse?.data);
  }

  static Future<GeneralResponseModel> deleteAccount() async {
    final deleteAccountResponse = await DioHelper.deletData(
      path: ApiPaths.profile,
    );
    AppLogger.info("deleteAccountResponse $deleteAccountResponse");
    try {
      if (deleteAccountResponse != null &&
          deleteAccountResponse.statusCode == 200) {
        return GeneralResponseModel.fromJson(deleteAccountResponse.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Delete Account is $e');
    }
    return GeneralResponseModel.fromJson(deleteAccountResponse?.data);
  }

  static Future<ConfigResponseModel> getConfigData() async {
    final configDataResponse = await DioHelper.getData(
      path: ApiPaths.configDataPath,
    );
    AppLogger.info("configDataResponse $configDataResponse");
    try {
      if (configDataResponse != null && configDataResponse.statusCode == 200) {
        return ConfigResponseModel.fromJson(configDataResponse.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Delete Account is $e');
    }
    return ConfigResponseModel.fromJson(configDataResponse?.data);
  }
}
