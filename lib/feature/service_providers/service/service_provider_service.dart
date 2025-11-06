import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_response.dart';

class ServiceProviderService {
  static Future<ServiceProviderResponse> getAllServiceProvider() async {
    final response = await DioHelper.getData(path: ApiPaths.serviceProvider);
    try {
      if (response != null && response.statusCode == 200) {
        return ServiceProviderResponse.fromJson(response.data);
      } else {
        return ServiceProviderResponse();
      }
    } catch (e) {
      AppLogger.error("Error in getAllFacilityBooking: $e");
    }

    return response?.data;
  }
}