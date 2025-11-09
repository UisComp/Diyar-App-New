import 'dart:convert';
import 'dart:developer';
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/notifications/model/general_notification_model.dart';
import 'package:diyar_app/feature/notifications/model/make_all_notification_as_read_response_model.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:http/http.dart' as http;

class NotificationsService {
  final LoginResponseModel _auth;
  NotificationsService._(this._auth);
  static Future<NotificationsService> create() async {
    try {
      final LoginResponseModel? authJson = await HiveHelper.getUserModel(
        AppConstants.userModelKey,
      );

      log('Auth JSON: $authJson');

      if (authJson == null) {
        return NotificationsService._(LoginResponseModel());
      } else {
        return NotificationsService._(authJson);
      }
    } catch (e) {
      log('Error creating NotificationsService: $e');
      throw Exception("Failed to create NotificationsService: $e");
    }
  }

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${_auth.data?.accessToken}",
  };

  Future<NotificationResponseModel> getAllNotifications({
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiPaths.baseUrl}${ApiPaths.getAllNotifications}?per_page=$perPage&unread_only=false',
        ),
        headers: _headers,
      );

      _logResponse(response, "getAllNotifications");
      final jsonData = jsonDecode(response.body);
      return NotificationResponseModel.fromJson(jsonData);
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  Future<GeneralNotificationModel> markNotificationAsRead(int id) async =>
      _handleRequest(
        () => http.get(
          Uri.parse(ApiPaths.markAsRead(id: "$id")),
          headers: _headers,
        ),
        (json) => GeneralNotificationModel.fromJson(json),
        "markNotificationAsRead",
      );

  Future<GeneralNotificationModel> deleteNotification(int id) async =>
      _handleRequest(
        () => http.delete(
          Uri.parse(ApiPaths.deleteNotification(id: "$id")),
          headers: _headers,
        ),
        (json) => GeneralNotificationModel.fromJson(json),
        "deleteNotification",
      );

  Future<MakeAllNotificationAsReadResponseModel>
  makeAllNotificationAsRead() async => _handleRequest(
    () => http.get(Uri.parse(ApiPaths.markAllAsRead), headers: _headers),
    (json) => MakeAllNotificationAsReadResponseModel.fromJson(json),
    "makeAllNotificationAsRead",
  );

  Future<T> _handleRequest<T>(
    Future<http.Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
    String context,
  ) async {
    try {
      final response = await request();
      _logResponse(response, context);
      return fromJson(jsonDecode(response.body));
    } catch (e) {
      log('Error in $context: $e');
      rethrow;
    }
  }

  void _logResponse(http.Response response, String context) {
    log('$context Response (${response.statusCode}): ${response.body}');
  }
}
