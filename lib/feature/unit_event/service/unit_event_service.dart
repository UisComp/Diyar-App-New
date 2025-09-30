import 'dart:developer';

import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/news_response_model.dart';

class UnitEventService {
  static Future<NewsResponseModel> getUnitsByEvent({required String id}) async {
    final unitEventResponse = await DioHelper.getData(
      path: ApiPaths.getNewsByUnit(id: id),
    );
    log("unitEventResponse==>$unitEventResponse");
    try {
      if (unitEventResponse != null && unitEventResponse.statusCode == 200) {
        return NewsResponseModel.fromJson(unitEventResponse.data);
      }
    } catch (e) {
      log('Error Happen While Get Units By Event is $e');
    }
    return NewsResponseModel.fromJson(unitEventResponse?.data);
  }
}
