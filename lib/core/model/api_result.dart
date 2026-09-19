import 'package:dio/dio.dart';

/// A parsed API response: `{ success, message, data, errors }`.
///
/// Failed responses from the phone-login endpoints carry a stable
/// `errors.code` (and `errors.retry_after` on 429s). Branch on [errorCode],
/// never on [message]: the message is for people and may change.
class ApiResult<T> {
  const ApiResult({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
    this.errorCode,
    this.retryAfter,
    this.fieldErrors = const {},
  });

  /// No response at all (offline, timeout, DNS…).
  const ApiResult.networkError()
    : success = false,
      statusCode = null,
      message = null,
      data = null,
      errorCode = null,
      retryAfter = null,
      fieldErrors = const {};

  final bool success;

  /// Null when the request never got a response.
  final int? statusCode;
  final String? message;
  final T? data;

  /// `errors.code`, e.g. `phone_not_registered`.
  final String? errorCode;

  /// `errors.retry_after` in seconds, on rate-limit errors.
  final int? retryAfter;

  /// Validation errors (422 without a code): field → messages.
  final Map<String, List<String>> fieldErrors;

  bool get isNetworkError => statusCode == null;

  /// The first validation message, if any.
  String? get firstFieldError {
    for (final messages in fieldErrors.values) {
      if (messages.isNotEmpty) return messages.first;
    }
    return null;
  }

  /// Builds a result from a Dio [response]. [parse] reads `data` on success;
  /// it's skipped when `data` isn't a JSON object.
  factory ApiResult.fromResponse(
    Response<dynamic>? response, {
    T Function(Map<String, dynamic> data)? parse,
  }) {
    if (response == null) return ApiResult<T>.networkError();
    return ApiResult<T>.fromJson(
      response.data,
      statusCode: response.statusCode,
      parse: parse,
    );
  }

  factory ApiResult.fromJson(
    dynamic body, {
    required int? statusCode,
    T Function(Map<String, dynamic> data)? parse,
  }) {
    final map = body is Map ? Map<String, dynamic>.from(body) : null;
    var ok =
        statusCode != null &&
        statusCode >= 200 &&
        statusCode < 300 &&
        map?['success'] != false;

    T? data;
    final rawData = map?['data'];
    if (ok && parse != null) {
      try {
        data = rawData is Map
            ? parse(Map<String, dynamic>.from(rawData))
            : null;
      } catch (_) {
        data = null;
      }
      // A success without the data we need is a failure for the caller.
      ok = data != null;
    }

    final errors = map?['errors'];
    String? code;
    int? retryAfter;
    final fieldErrors = <String, List<String>>{};
    if (errors is Map) {
      if (errors['code'] is String) code = errors['code'] as String;
      final retry = errors['retry_after'];
      retryAfter = retry is num ? retry.toInt() : int.tryParse('$retry');
      if (code == null) {
        errors.forEach((key, value) {
          if (value is List) {
            fieldErrors['$key'] = [for (final v in value) '$v'];
          } else if (value != null) {
            fieldErrors['$key'] = ['$value'];
          }
        });
      }
    } else if (errors is List && errors.isNotEmpty) {
      // e.g. the unit check: `"errors": ["Unit code does not exist"]`.
      fieldErrors['_'] = [for (final e in errors) '$e'];
    }

    return ApiResult<T>(
      success: ok,
      statusCode: statusCode,
      message: map?['message']?.toString(),
      data: data,
      errorCode: code,
      retryAfter: retryAfter,
      fieldErrors: fieldErrors,
    );
  }
}
