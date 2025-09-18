import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/api/api_paths.dart';

class DioHelper {
  static Dio? dio;
  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.baseUrl,
        receiveDataWhenStatusError: true,
        validateStatus: (validateStatus) => true,
        headers: {"content-type": 'application/json; charset=utf-8'},
        connectTimeout: ApiPaths.timeOutDuration,
        receiveTimeout: ApiPaths.timeOutDuration,
        sendTimeout: ApiPaths.timeOutDuration,
        responseType: ResponseType.json,
      ),
    );
  }

  static Future<Response?> getData({
    required String path,
    dynamic queryParameters,
    bool needHeader = true,
  }) async {
    try {
      return await dio?.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (_) => true,
          // headers: needHeader ? await ApiPaths.getHeaders() : null,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response);
      log(errorMsg);
    }
    return null;
  }

  static Future<Response?> postData({
    required String path,
    data,
    needHeader = true,
  }) async {
    try {
      return await dio!.post(
        path,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/json',
          // headers: needHeader ? await ApiPaths.getHeaders() : null,
          followRedirects: false,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response!);
      log(errorMsg);
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
          // headers: needHeader ? await ApiPaths.getHeaders() : null,
          followRedirects: false,
        ),
      );
    } on SocketException catch (_) {
    } on DioException catch (e) {
      String errorMsg = _handleResponse(e.response!);
      log(errorMsg);
    }
    return null;
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