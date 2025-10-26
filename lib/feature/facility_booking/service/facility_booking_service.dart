import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';

class FacilityBookingService {
  static Future<FacilityModel> getAllFacilityBooking() async {
    final response = await DioHelper.getData(path: ApiPaths.facilityBooking);
    try {
      if (response != null && response.statusCode == 200) {
        return FacilityModel.fromJson(response.data);
      } else {
        return FacilityModel();
      }
    } catch (e) {
      AppLogger.error("Error in getAllFacilityBooking: $e");
    }

    return response?.data;
  }
}
