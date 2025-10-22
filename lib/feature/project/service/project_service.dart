import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';

class ProjectService {
  static Future<ProjectsResponseModel> getProjects() async {
    final projectResponse = await DioHelper.getData(path: ApiPaths.getProjects);
    try {
      AppLogger.info("projectResponse==>$projectResponse");
      if (projectResponse != null && projectResponse.statusCode == 200) {
        return ProjectsResponseModel.fromJson(projectResponse.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Projects is $e');
    }
    return ProjectsResponseModel.fromJson(projectResponse?.data);
  }

  static Future<ProjectDetailsResponseModel> getProjectDetails({
    required String id,
  }) async {
    final projectResponseDetails = await DioHelper.getData(
      path: ApiPaths.getProjectDetails(id: id),
    );
    try {
      AppLogger.info("projectResponseDetails==>$projectResponseDetails");
      if (projectResponseDetails != null &&
          projectResponseDetails.statusCode == 200) {
        return ProjectDetailsResponseModel.fromJson(projectResponseDetails.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Project Details is $e');
    }
    return ProjectDetailsResponseModel.fromJson(projectResponseDetails?.data);
  }
}
