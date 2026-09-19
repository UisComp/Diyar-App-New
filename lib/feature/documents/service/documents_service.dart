import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';

abstract class DocumentsService {
  static Future<DocumentsResponseModel> getDocuments() async {
    final response = await DioHelper.getData(path: ApiPaths.getDocumentPath);
    final body = response?.data;
    if (body is Map<String, dynamic>) {
      AppLogger.success("Get Documents: $body");
      return DocumentsResponseModel.fromJson(body);
    }
    AppLogger.error("Error While Get Documents: ${response?.statusCode}");
    return DocumentsResponseModel(success: false);
  }
}
