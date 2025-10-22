import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/home/model/user_services_model.dart';

class HomeService {
  static Future<UserServicesResponse> getAllServices() async {
    final response = await DioHelper.getData(path: ApiPaths.getAllServices);
    AppLogger.info('getAllServices path ==> ${ApiPaths.getAllServices}');
    try {
      AppLogger.info('getAllServices==> ${response?.data}');
      if (response != null && response.statusCode == 200) {
        return UserServicesResponse.fromJson(response.data);
      } else {
        return UserServicesResponse.fromJson(response?.data);
      }
    } catch (e) {
      AppLogger.error('Error Happen While Get All Services is $e');
      return UserServicesResponse.fromJson(response?.data);
    }
  }
}
