import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/visitor/model/scan_qr_code_response_model.dart';
import 'package:diyar_app/feature/visitor/model/visitor_pass_request.dart';
import 'package:diyar_app/feature/visitor/model/visitor_pass_response.dart';

class VisitorService {
  static Future<VisitorPassResponse> createVisitorPass({
    VisitorPassRequest? visitorPassRequest,
  }) async {
    final visitorPassResponse = await DioHelper.postData(
      path: ApiPaths.visitorPassesPath,
      data: visitorPassRequest?.toJson(),
    );
    AppLogger.log('visitorPassResponse: $visitorPassResponse');
    if (visitorPassResponse != null && visitorPassResponse.statusCode == 201) {
      return VisitorPassResponse.fromJson(visitorPassResponse.data);
    } else {
      return VisitorPassResponse.fromJson(visitorPassResponse?.data);
    }
  }

  static Future<ScanQrCodeResponseModel> scanQrCode({String? token}) async {
    final visitorPassscanResponse = await DioHelper.postData(
      path: ApiPaths.visitorPassesPathScan,
      data: {"token": token},
    );
    AppLogger.log('visitorPassResponse: $visitorPassscanResponse');
    if (visitorPassscanResponse != null &&
        visitorPassscanResponse.statusCode == 200) {
      return ScanQrCodeResponseModel.fromJson(visitorPassscanResponse.data);
    } else {
      return ScanQrCodeResponseModel.fromJson(visitorPassscanResponse?.data);
    }
  }
}
