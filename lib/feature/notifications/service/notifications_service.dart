import 'dart:convert';
import 'dart:developer';
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/notifications/model/general_notification_model.dart';
import 'package:diyar_app/feature/notifications/model/make_all_notification_as_read_response_model.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:dio/dio.dart';

class NotificationsService {
  NotificationsService._();

  static Future<NotificationsService> create() async {
    try {
      final LoginResponseModel? authJson = await HiveHelper.getUserModel(
        AppConstants.userModelKey,
      );
      log("Auth JSON => $authJson");

      return NotificationsService._();
    } catch (e) {
      log('Error creating NotificationsService: $e');
      throw Exception("Failed to create NotificationsService: $e");
    }
  }

  Future<NotificationResponseModel> getAllNotifications({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      Response? response = await DioHelper.getData(
        needHeader: true,
        path: ApiPaths.getAllNotifications(page: page, perPage: perPage),
      );

      _logResponse(response, "getAllNotifications");

      return NotificationResponseModel.fromJson(response?.data);
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  Future<GeneralNotificationModel> markNotificationAsRead(int id) async =>
      _handleRequest(
        () => DioHelper.postData(path: ApiPaths.markAsRead(id: "$id")),
        (json) => GeneralNotificationModel.fromJson(json),
        "markNotificationAsRead",
      );
  Future<GeneralNotificationModel> deleteNotification(int id) async =>
      _handleRequest(
        () => DioHelper.deletData(path: ApiPaths.deleteNotification(id: "$id")),
        (json) => GeneralNotificationModel.fromJson(json),
        "deleteNotification",
      );
  Future<MakeAllNotificationAsReadResponseModel>
  makeAllNotificationAsRead() async => _handleRequest(
    () => DioHelper.postData(path: ApiPaths.markAllAsRead),
    (json) => MakeAllNotificationAsReadResponseModel.fromJson(json),
    "makeAllNotificationAsRead",
  );
  Future<T> _handleRequest<T>(
    Future<Response?> Function() request,
    T Function(Map<String, dynamic>) fromJson,
    String context,
  ) async {
    try {
      final response = await request();

      _logResponse(response, context);

      if (response?.data is Map<String, dynamic>) {
        return fromJson(response?.data);
      } else {
        return fromJson(jsonDecode(response?.data));
      }
    } catch (e) {
      log('Error in $context: $e');
      rethrow;
    }
  }

  void _logResponse(Response? res, String context) {
    log("$context Response (${res?.statusCode}): ${res?.data}");
  }
}
