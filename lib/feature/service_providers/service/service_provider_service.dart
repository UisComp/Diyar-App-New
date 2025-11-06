import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/service_providers/model/create_service_provider_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/request_service_provider_model.dart';
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

  static Future<CreateServiceProviderResponseModel>
  createServiceProviderRequest({
    RequestServiceProviderModel? requestServiceProviderModel,
  }) async {
    final response = await DioHelper.postData(
      path: ApiPaths.createServiceProvider,
      data: requestServiceProviderModel?.toJson(),
    );
    AppLogger.log(
      "serviceProvider request is ${requestServiceProviderModel?.services?.map((e) => e.toJson())}",
    );
    try {
      if (response != null && response.statusCode == 201) {
        return CreateServiceProviderResponseModel.fromJson(response.data);
      } else {
        return CreateServiceProviderResponseModel();
      }
    } catch (e) {
      AppLogger.error("Error in create service provider request: $e");
    }

    return response?.data;
  }
}
