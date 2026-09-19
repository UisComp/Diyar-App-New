import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';

class ApiPaths {
  static Duration timeOutDuration = const Duration(seconds: 20);
  static Duration sendTimeOutDuration = const Duration(seconds: 20);
  static const String baseUrl = "https://diyar.uisdevs.com/api/";

  //! Residents: phone + password. SMS codes only for registration, the
  //! first login of accounts created by staff, and a forgotten password.
  static const String loginOtp = "auth/otp";
  static const String loginOtpVerify = "auth/otp/verify";
  static const String setPassword = "auth/password";
  /// Phone number or email + password, for everyone.
  static const String authLogin = "auth/login";
  static const String registerOtp = "auth/register/otp";
  static const String registerVerify = "auth/register/verify";
  static const String register = "auth/register";

  //! Security staff: the email password reset.
  static const String forgetPassword = "password/request-otp";
  static const String verifyOtp = "password/verify-otp";
  static const String resetPassword = "password/reset";

  /// Logs out this device only (same as `auth/logout`).
  static const String logOut = "logout";
  static const String profile = "profile";
  static const String changePassword = "profile/change-password";
  static const String fcmToken = "profile/fcm-token";

  //! Phone numbers of the signed-in resident.
  static const String phones = "profile/phones";
  static const String phonesOtp = "profile/phones/otp";
  static const String phoneRequests = "profile/phone-requests";
  static String phoneRequest(int id) => "profile/phone-requests/$id";
  static String makePhonePrimary(int id) => "profile/phones/$id/primary";
  // static final String getAllServices = userModel?.data?.accessToken != null
  //     ? "services/user"
  //     : "services";
  static String get getAllServices {
    final hasToken = userModel?.data?.accessToken != null;
    AppLogger.info('API Path check - Has token: $hasToken');
    return hasToken ? "services/user" : "services";
  }

  static const String getAllAnnouncementsBannersPath = "announcements";
  static const String getLinkedUnitsForUser = "units";
  static const String getProjects = "projects";
  static const String getUserProjects = "projects/user";
  static const String facilityBooking = "facilities";
  static const String createFacilityRequest = "facility-bookings";
  static const String createServiceProvider = "service-provider-bookings";
  static const String serviceProvider = "service-providers";
  static const String getDocumentPath = "profile/documents";
  static const String financePath = "user/finance";
  static final String getAllNews = userModel?.data?.accessToken != null
      ? "news/user"
      : "news";
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
  static String serviceProviderHistory = "service-provider-bookings";
  static String facilityBookingHistory = "facility-bookings";
  static String getNewsByUnit({
    required String id,
    String? start,
    String? end,
  }) => "/news/unit/$id?start=$start&end=$end";
  static String getNewsByProject({
    required String id,
    String? start,
    String? end,
  }) => "/news/project/$id?start=$start&end=$end";
  static String getUnitById({String? id}) => "units/$id";
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
