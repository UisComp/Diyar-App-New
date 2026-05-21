import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/service_providers/model/create_service_provider_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/request_service_provider_model.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_history_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_response.dart';

class ServiceProviderService {
  static Future<ServiceProviderResponse> getAllServiceProvider() async {
    final response = await DioHelper.getData(path: ApiPaths.serviceProvider);
    try {
      if (response?.data is Map<String, dynamic>) {
        return ServiceProviderResponse.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in getAllServiceProvider: $e");
    }
    return ServiceProviderResponse(success: false, message: 'Parsing failed');
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
      if (response?.data is Map<String, dynamic>) {
        return CreateServiceProviderResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in create service provider request: $e");
    }
    return CreateServiceProviderResponseModel(
      success: false,
      message: 'Parsing failed',
    );
  }

  static Future<ServiceProviderHistoryResponseModel>
  getServiceProviderHistory() async {
    final response = await DioHelper.getData(
      path: ApiPaths.serviceProviderHistory,
    );
    try {
      if (response?.data is Map<String, dynamic>) {
        return ServiceProviderHistoryResponseModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      AppLogger.error("Error in getServiceProviderHistory: $e");
    }
    return ServiceProviderHistoryResponseModel(
      success: false,
      message: 'Parsing failed',
    );
  }
}
