import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/unit_event/model/news_by_project_unit_event_response_model.dart';

class UnitEventService {
  static Future<NewByProjectUnitEventResponseModel> getNewsByProjectUnitsByEvent({required String id}) async {
    final unitEventResponse = await DioHelper.getData(
      path: ApiPaths.getNewsByUnit(id: id),
    );
    AppLogger.info("unitEventResponse==>$unitEventResponse");
    try {
      if (unitEventResponse != null && unitEventResponse.statusCode == 200) {
        return NewByProjectUnitEventResponseModel.fromJson(unitEventResponse.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get Units By Event is $e');
    }
    return NewByProjectUnitEventResponseModel.fromJson(unitEventResponse?.data);
  }
}
