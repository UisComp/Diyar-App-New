class ApiPaths {
  static const String baseUrl = "";
  static Duration timeOutDuration = const Duration(seconds: 10);
  static const String register = "/register";
  static const String login = "/login";
  static const String profile = "/profile";
  static const String changePassword = "/profile/change-password";
  static const String forgetPassword = "/password/request-otp";
  static const String verifyOtp="/password/verify-otp";
  static const String resetPassword = "/reset-password";
  static const String getUserProjects = "/profile/projects";
  static const String getProjects = "/projects";
 static const String getAllNews ="/news";
  static String getProjectDetails({required String id}) => "/projects/$id";
  static String getNewsByUnit({required String id}) => "/news/unit/$id";
  static Future<Map<String, dynamic>> getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}