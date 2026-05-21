import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_request_model.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';

class FacilityBookingService {
  static Future<FacilityResponse> getAllFacilityBooking() async {
    final response = await DioHelper.getData(path: ApiPaths.facilityBooking);
    try {
      if (response?.data is Map<String, dynamic>) {
        return FacilityResponse.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in getAllFacilityBooking: $e");
    }
    return FacilityResponse(success: false, message: 'Parsing failed');
  }

  static Future<CreateRequestFacilityResponseModel> createFacilityRequest({
    CreateRequestFacilityRequestModel? createRequestFacilityRequestModel,
  }) async {
    final response = await DioHelper.postData(
      path: ApiPaths.createFacilityRequest,
      data: createRequestFacilityRequestModel?.toJson(),
    );
    try {
      if (response?.data is Map<String, dynamic>) {
        return CreateRequestFacilityResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in create Facility request: $e");
    }
    return CreateRequestFacilityResponseModel(
      success: false,
      message: 'Parsing failed',
    );
  }

  static Future<FacilityBookingHistoryResponseModel>
  getFacilityBookingHistory() async {
    final response = await DioHelper.getData(
      path: ApiPaths.facilityBookingHistory,
    );
    try {
      if (response?.data is Map<String, dynamic>) {
        return FacilityBookingHistoryResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in getFacilityBookingHistory: $e");
    }
    return FacilityBookingHistoryResponseModel(
      success: false,
      message: 'Parsing failed',
    );
  }
}
