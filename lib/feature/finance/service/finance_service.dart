import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/finance/model/documents_response_model.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';

abstract class FinanceService {
  static Future<FinanceResponseModel> getFinance() async {
    final response = await DioHelper.getData(path: ApiPaths.financePath);
    try {
      if (response != null && response.statusCode == 200) {
        AppLogger.success("Get Finance: ${response.data}");
        return FinanceResponseModel.fromJson(response.data);
      }
    } catch (e) {
      AppLogger.error("Error While Get Finance: $e");
    }
    return FinanceResponseModel.fromJson(response?.data);
  }

  static Future<DocumentsResponseModel> getDocuments() async {
    final response = await DioHelper.getData(path: ApiPaths.getDocumentPath);

    try {
      if (response != null && response.statusCode == 200) {
        AppLogger.success("Get Documents: ${response.data}");
        return DocumentsResponseModel.fromJson(response.data);
      }
    } catch (e) {
      AppLogger.error("Error While Get Documents: $e");
    }
    return DocumentsResponseModel.fromJson(response?.data);
  }
}
