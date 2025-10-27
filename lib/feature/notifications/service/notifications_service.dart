// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;

// class NotificationsService {
//   final Auth _auth;

//   NotificationsService._(this._auth);

//   static Future<NotificationsService> create() async {
//     try {
//       // final preferences = await SharedPreferences.getInstance();
//       final authJson = preferences.getString(AppConstant.Share_Auth);
//       log('Auth JSON: $authJson');
//       if (authJson == null || authJson.isEmpty) {
//         // throw Exception("Missing auth token");
//         return NotificationsService._(Auth());
//       } else {
//         final auth = Auth.fromJson(jsonDecode(authJson));

//         return NotificationsService._(auth);
//       }
//     } catch (e) {
//       log('Error creating NotificationsService: $e');
//       throw Exception("Failed to create NotificationsService: $e");
//     }
//   }

//   Map<String, String> get _headers => {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer ${_auth.data?.token}",
//       };

//   Future<NotificationResponseModel> getAllNotifications({
//     int page = 1,
//     int perPage = 5,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${URL.getAllNotifications}?per_page=$perPage&page=$page'),
//         headers: _headers,
//       );

//       _logResponse(response, "getAllNotifications");
//       final jsonData = jsonDecode(response.body);
//       return NotificationResponseModel.fromJson(jsonData);
//     } catch (e) {
//       log('Error: $e');
//       rethrow;
//     }
//   }

//   Future<GeneralNotificationModel> markNotificationAsRead(int id) async =>
//       _handleRequest(
//         () => http.get(Uri.parse(URL.markAsRead("$id")), headers: _headers),
//         (json) => GeneralNotificationModel.fromJson(json),
//         "markNotificationAsRead",
//       );

//   Future<GeneralNotificationModel> deleteNotification(int id) async =>
//       _handleRequest(
//         () => http.delete(Uri.parse(URL.deleteNotification("$id")),
//             headers: _headers),
//         (json) => GeneralNotificationModel.fromJson(json),
//         "deleteNotification",
//       );

//   Future<MakeAllNotificationAsReadResponseModel>
//       makeAllNotificationAsRead() async => _handleRequest(
//             () => http.get(Uri.parse(URL.markAllAsRead), headers: _headers),
//             (json) => MakeAllNotificationAsReadResponseModel.fromJson(json),
//             "makeAllNotificationAsRead",
//           );

//   Future<T> _handleRequest<T>(
//     Future<http.Response> Function() request,
//     T Function(Map<String, dynamic>) fromJson,
//     String context,
//   ) async {
//     try {
//       final response = await request();
//       _logResponse(response, context);
//       return fromJson(jsonDecode(response.body));
//     } catch (e) {
//       log('Error in $context: $e');
//       rethrow;
//     }
//   }

//   void _logResponse(http.Response response, String context) {
//     log('$context Response (${response.statusCode}): ${response.body}');
//   }
// }