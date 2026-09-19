import 'package:dio/dio.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/model/api_result.dart';

/// Sends a request and parses it into an [ApiResult]. Never throws: an
/// exception becomes [ApiResult.networkError].
///
/// Logs only the path and status: bodies can hold passwords and tokens.
Future<ApiResult<T>> apiRequest<T>(
  String label,
  Future<Response<dynamic>?> Function() send, {
  T Function(Map<String, dynamic> data)? parse,
}) async {
  try {
    final response = await send();
    final result = ApiResult<T>.fromResponse(response, parse: parse);
    if (result.success) {
      AppLogger.info('$label ==> ${result.statusCode}');
    } else {
      AppLogger.warning(
        '$label ==> ${result.statusCode ?? 'no response'} '
        '${result.errorCode ?? result.message ?? ''}',
      );
    }
    return result;
  } catch (e, st) {
    AppLogger.error('Error while $label: $e\n$st');
    return ApiResult<T>.networkError();
  }
}
