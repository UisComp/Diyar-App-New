import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_request_model.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';

class FacilityBookingService {
  static Future<FacilityResponse> getAllFacilityBooking() async {
    final response = await DioHelper.getData(path: ApiPaths.facilityBooking);
    try {
      if (response != null && response.statusCode == 200) {
        return FacilityResponse.fromJson(response.data);
      } else {
        return FacilityResponse.fromJson(response?.data);
      }
    } catch (e) {
      AppLogger.error("Error in getAllFacilityBooking: $e");
    }

    return response?.data;
  }

  static Future<CreateRequestFacilityResponseModel> createFacilityRequest({
    CreateRequestFacilityRequestModel? createRequestFacilityRequestModel,
  }) async {
    final response = await DioHelper.postData(
      path: ApiPaths.createFacilityRequest,
      data: createRequestFacilityRequestModel?.toJson(),
    );
    try {
      if (response != null && response.statusCode == 201) {
        return CreateRequestFacilityResponseModel.fromJson(response.data);
      } else {
        return CreateRequestFacilityResponseModel.fromJson(response?.data);
      }
    } catch (e) {
      AppLogger.error("Error in create Facility request: $e");
    }

    return response?.data;
  }
}
