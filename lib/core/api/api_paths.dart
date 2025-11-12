import 'package:diyar_app/core/constants/app_variable.dart';

class ApiPaths {
  static Duration timeOutDuration = const Duration(seconds: 20);
  static Duration sendTimeOutDuration = const Duration(seconds: 20);
  static const String baseUrl = "https://diyar.sherif-elzeny.com/api/";
  static const String register = "register";
  static const String login = "login";
  static const String logOut = "logout";
  static const String profile = "profile";
  static const String changePassword = "profile/change-password";
  static const String forgetPassword = "password/request-otp";
  static const String verifyOtp = "password/verify-otp";
  static const String resetPassword = "password/reset";
  static const String getAllServices = "services/user";
  static const String getAllAnnouncementsBannersPath = "announcements";
  static const String getLinkedUnitsForUser = "units";
  static const String getUserProjects = "profile/projects";
  static const String getProjects = "projects";
  static const String facilityBooking = "facilities";
  static const String createFacilityRequest = "facility-bookings";
  static const String createServiceProvider = "service-provider-bookings";
  static const String serviceProvider = "service-providers";
  static const String getDocumentPath = "profile/documents";
  static const String financePath = "user/finance";
  static const String getAllNews = "news/user";
  static const String configDataPath = "config";
  static const visitorPassesPath = "visitor-passes";
  static const visitorPassesPathScan = "visitor-passes/validate";
  static String getAllNotifications({int? perPage, int? page}) =>
      "notifications?per_page=$perPage&page=$page&unread_only=false";
  static String markAsRead({required String id}) =>
      "notifications/$id/mark-read";
  static String markAllAsRead = "notifications/mark-all-read";
  static String deleteNotification({required String id}) => "notifications/$id";
  static String getProjectDetails({required String id}) => "projects/$id";
  static String getNewsByUnit({
    required String id,
    String? start,
    String? end,
  }) => "news/project/$id?start=$start&end=$end";
  static String newsDetails({required String id}) => "news/$id";
  static Future<Map<String, dynamic>> getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (userModel?.data?.accessToken != null)
        'Authorization': 'Bearer ${userModel?.data?.accessToken}',
    };
  }
}
