import 'package:diyar_app/core/constants/app_variable.dart';

class ApiPaths {
  static Duration timeOutDuration = const Duration(seconds: 10);
  static Duration sendTimeOutDuration = const Duration(seconds: 10);
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
  static const String facilityBooking = "";
  static const String getDocumentPath = "profile/documents";
  static const String financePath = "user/finance";
  static const String getAllNews = "news/user?per_page=15"; //! paginate
  static const String configDataPath = "config";
  static String getProjectDetails({required String id}) => "projects/$id";
  static String getNewsByUnit({required String id}) =>
      "news/project/$id?per_page=15"; //! paginate
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
