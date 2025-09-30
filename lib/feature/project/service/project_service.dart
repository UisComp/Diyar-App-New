import 'dart:developer';

import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/project/model/project_details_response.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';

class ProjectService {
  static Future<ProjectsResponseModel> getProjects() async {
    final projectResponse = await DioHelper.getData(path: ApiPaths.getProjects);
    try {
      log("projectResponse==>$projectResponse");
      if (projectResponse != null && projectResponse.statusCode == 200) {
        return ProjectsResponseModel.fromJson(projectResponse.data);
      }
    } catch (e) {
      log('Error Happen While Get Projects is $e');
    }
    return ProjectsResponseModel.fromJson(projectResponse?.data);
  }

  static Future<ProjectDetailsResponse> getProjectDetails({
    required String id,
  }) async {
    final projectResponseDetails = await DioHelper.getData(
      path: ApiPaths.getProjectDetails(id: id),
    );
    try {
      log("projectResponseDetails==>$projectResponseDetails");
      if (projectResponseDetails != null &&
          projectResponseDetails.statusCode == 200) {
        return ProjectDetailsResponse.fromJson(projectResponseDetails.data);
      }
    } catch (e) {
      log('Error Happen While Get Project Details is $e');
    }
    return ProjectDetailsResponse.fromJson(projectResponseDetails?.data);
  }
}
