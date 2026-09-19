import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? dio;

  /// Called when the API rejects the signed-in user's own token with `401`
  /// (expired or revoked). Set in `main`.
  static Future<void> Function()? onSessionExpired;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.baseUrl,
        receiveDataWhenStatusError: true,
        validateStatus: (validateStatus) => true,
        // Accept JSON so the API answers errors (401/403/422/429) with its
        // JSON envelope instead of a redirect.
        headers: {
          "content-type": 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        connectTimeout: ApiPaths.timeOutDuration,
        receiveTimeout: ApiPaths.timeOutDuration,
        sendTimeout: ApiPaths.sendTimeOutDuration,
        responseType: ResponseType.json,
      ),
    );

    dio!.interceptors.add(sessionInterceptor());

    dio!.interceptors.add(
      PrettyDioLogger(
        enabled: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
        error: true,
        request: true,
        maxWidth: 120,
      ),
    );
  }

  static Future<Response?> getData({
    required String path,
    dynamic queryParameters,
    bool needHeader = true,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio?.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (_) => true,
          headers: await _headers(needHeader, headers),
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      AppLogger.error(errorMsg);
    }
    return null;
  }

  static Future<Response?> postData({
    required String path,
    data,
    needHeader = true,
    isFormData = false,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio!.post(
        path,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: isFormData ? "multipart/form-data" : 'application/json',
          headers: await _headers(needHeader, headers),
          followRedirects: false,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      AppLogger.error(errorMsg);
    }
    return null;
  }

  static Future<Response?> putData({
    required String path,
    data,
    needHeader = true,
  }) async {
    try {
      return await dio!.put(
        path,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/json',
          headers: needHeader ? await ApiPaths.getHeaders() : null,
          followRedirects: false,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      AppLogger.error(errorMsg);
    }
    return null;
  }

  static Future<Response?> deletData({
    required String path,
    data,
    needHeader = true,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio!.delete(
        path,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/json',
          headers: await _headers(needHeader, headers),
          followRedirects: false,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      AppLogger.error(errorMsg);
    }
    return null;
  }

  static Future<Response?> patchData({
    required String path,
    data,
    needHeader = true,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio!.patch(
        path,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/json',
          headers: await _headers(needHeader, headers),
          followRedirects: false,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      AppLogger.error(errorMsg);
    }
    return null;
  }

  /// The signed-in user's headers when [needHeader], with [extra] on top
  /// (e.g. a one-off `Authorization` for the password setup token).
  static Future<Map<String, dynamic>?> _headers(
    bool needHeader,
    Map<String, dynamic>? extra,
  ) async {
    if (!needHeader && extra == null) return null;
    return {if (needHeader) ...await ApiPaths.getHeaders(), ...?extra};
  }

  /// Calls [onSessionExpired] when the signed-in user's token is rejected.
  static Interceptor sessionInterceptor() => InterceptorsWrapper(
    onResponse: (response, handler) {
      if (_isExpiredSession(response)) onSessionExpired?.call();
      handler.next(response);
    },
  );

  /// A `401` for a request sent with the signed-in user's token. A `401`
  /// without it (e.g. a guest opening a unit's news) or with another token
  /// (the password setup token) isn't a lost session. Logging out with a dead
  /// token is left to the logout flow.
  static bool _isExpiredSession(Response response) {
    if (response.statusCode != 401) return false;
    final token = userModel?.data?.accessToken;
    if (token == null) return false;
    final options = response.requestOptions;
    if (options.path == ApiPaths.logOut) return false;
    final sent =
        options.headers['Authorization'] ?? options.headers['authorization'];
    return sent == 'Bearer $token';
  }

  static String _handleResponse(Response? response) {
    if (response == null) {
      var jsonResponse = 'connection error';
      return jsonResponse;
    }
    switch (response.statusCode) {
      case 400:
        var jsonResponse = 'UnAuth';
        return jsonResponse;
      case 401:
        var jsonResponse = 'UnAuth';
        return jsonResponse;
      case 403:
        var jsonResponse = 'UnAuth';
        return jsonResponse;
      case 404:
        var jsonResponse = 'Not found';
        return jsonResponse;
      case 422:
        var jsonResponse = 'some fields required! or error with entry data';
        return jsonResponse;
      case 500:
        var jsonResponse = 'server error';
        return jsonResponse;
      default:
        var jsonResponse = 'server error';
        return jsonResponse;
    }
  }
}
