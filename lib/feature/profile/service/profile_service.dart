import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';

class ProfileService {
  static Future<ProfileResponseModel> getProfile() async {
    final profileResponse = await DioHelper.getData(path: ApiPaths.profile);

    try {
      AppLogger.info("profileResponse==>$profileResponse");
      if (profileResponse != null && profileResponse.statusCode == 200) {
        return ProfileResponseModel.fromJson(profileResponse.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Profile is $e');
    }
    return ProfileResponseModel.fromJson(profileResponse?.data);
  }
  static Future<ProfileResponseModel> editProfile({
    RequestModel? authRequestModel,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "_method": "PUT",
        "name": authRequestModel?.name,
        "email": authRequestModel?.email,
        "phone_number": authRequestModel?.phoneNumber,
        if (image != null)
          "profile_picture": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await DioHelper.postData(
        path: ApiPaths.profile,
        data: formData,
        isFormData: true,
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      );

      AppLogger.info("editProfileResponse==>${response?.data}");

      if (response != null && response.statusCode == 200) {
        return ProfileResponseModel.fromJson(response.data);
      } else {
        return ProfileResponseModel.fromJson(response?.data);
      }
    } catch (e, stack) {
      AppLogger.error('Error Happen While Editing Profile $e\n$stack');
      return ProfileResponseModel(success: false, message: e.toString());
    }
  }

  static Future<UserUnitsResponseModel> getLinkedUnitsForUser() async {
    final response = await DioHelper.getData(
      path: ApiPaths.getLinkedUnitsForUser,
    );
    try {
      AppLogger.info('getLinkedUnitsForUser==> ${response?.data}');
      if (response != null && response.statusCode == 200) {
        return UserUnitsResponseModel.fromJson(response.data);
      } else {
        return UserUnitsResponseModel.fromJson(response?.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Linked Units For User is $e');
      return UserUnitsResponseModel.fromJson(response?.data);
    }
  }
}
