import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/unit_event/model/news_by_project_unit_event_response_model.dart';

class UnitEventService {
  static Future<NewByProjectUnitEventResponseModel>
  getNewsByProjectUnitsByEvent({
    required String id,
    DateTime? start,
    DateTime? end,
  }) async {
    final unitEventResponse = await DioHelper.getData(
      path: ApiPaths.getNewsByUnit(
        id: id,
        start: start.toString(),
        end: end.toString(),
      ),
    );
    AppLogger.info("unitEventResponse==>$unitEventResponse");
    try {
      if (unitEventResponse != null && unitEventResponse.statusCode == 200) {
        return NewByProjectUnitEventResponseModel.fromJson(
          unitEventResponse.data,
        );
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Units By Event is $e');
    }
    return NewByProjectUnitEventResponseModel.fromJson(unitEventResponse?.data);
  }

  /// Fetches every news item for a whole project within an optional date range.
  /// Returns the same shape as the unit endpoint so the timeline can render
  /// both with one model.
  static Future<NewByProjectUnitEventResponseModel> getNewsByProjectByEvent({
    required String id,
    DateTime? start,
    DateTime? end,
  }) async {
    final projectEventResponse = await DioHelper.getData(
      path: ApiPaths.getNewsByProject(
        id: id,
        start: start.toString(),
        end: end.toString(),
      ),
    );
    AppLogger.info("projectEventResponse==>$projectEventResponse");
    try {
      if (projectEventResponse != null &&
          projectEventResponse.statusCode == 200) {
        return NewByProjectUnitEventResponseModel.fromJson(
          projectEventResponse.data,
        );
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Project News By Event is $e');
    }
    return NewByProjectUnitEventResponseModel.fromJson(
      projectEventResponse?.data,
    );
  }
}
