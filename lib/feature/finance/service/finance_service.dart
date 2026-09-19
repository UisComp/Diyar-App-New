import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';

abstract class FinanceService {
  /// `GET /api/user/finance`: every unit the customer owns (including units
  /// without a payment plan), with financials and plan rows.
  static Future<FinanceResponseModel> getFinance() async {
    final response = await DioHelper.getData(path: ApiPaths.financePath);
    final body = response?.data;
    if (body is Map<String, dynamic>) {
      AppLogger.success("Get Finance: $body");
      return FinanceResponseModel.fromJson(body);
    }
    AppLogger.error("Error While Get Finance: ${response?.statusCode}");
    return const FinanceResponseModel(success: false);
  }
}
