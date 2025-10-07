import 'dart:developer';

import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';

class ProfileService {
  static Future<ProfileResponseModel> getProfile() async {
    final profileResponse = await DioHelper.getData(path: ApiPaths.profile);

    try {
      log("profileResponse==>$profileResponse");
      if (profileResponse != null && profileResponse.statusCode == 200) {
        return ProfileResponseModel.fromJson(profileResponse.data);
      }
    } catch (e) {
      log('Error Happen While Get Profile is $e');
    }
    return ProfileResponseModel.fromJson(profileResponse?.data);
  }

  static Future<ProfileResponseModel> editProfile({
    RequestModel? authRequestModel,
  }) async {
    final editProfileResponse = await DioHelper.patchData(
      path: ApiPaths.profile,
      data: authRequestModel?.toJson(),
    );

    try {
      log("editProfileResponse==>$editProfileResponse");
      if (editProfileResponse != null &&
          editProfileResponse.statusCode == 200) {
        return ProfileResponseModel.fromJson(editProfileResponse.data);
      }
    } catch (e) {
      log('Error Happen While Get Profile is $e');
    }
    return ProfileResponseModel.fromJson(editProfileResponse?.data);
  }

  static Future<ProfileResponseModel> getUserProjects() async {
    final userProjectsResponse = await DioHelper.getData(
      path: ApiPaths.getUserProjects,
    );

    try {
      log("userProjectsResponse==>$userProjectsResponse");
      if (userProjectsResponse != null &&
          userProjectsResponse.statusCode == 200) {
        return ProfileResponseModel.fromJson(userProjectsResponse.data);
      }
    } catch (e) {
      log('Error Happen While Get Profile is $e');
    }
    return ProfileResponseModel.fromJson(userProjectsResponse?.data);
  }

  static Future<UserUnitsResponseModel> getLinkedUnitsForUser() async {
    final response = await DioHelper.getData(
      path: ApiPaths.getLinkedUnitsForUser,
    );
    try {
      log('getLinkedUnitsForUser==> ${response?.data}');
      if (response != null && response.statusCode == 200) {
        return UserUnitsResponseModel.fromJson(response.data);
      } else {
        return UserUnitsResponseModel.fromJson(response?.data);
      }
    } catch (e) {
      log('Error Happen While Get Linked Units For User is $e');
      return UserUnitsResponseModel.fromJson(response?.data);
    }
  }
}
