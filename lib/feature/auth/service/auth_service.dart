import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/api_request.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/model/reset_or_forget_password_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_password_request_model.dart';
import 'package:diyar_app/feature/auth/model/verify_otp_response_model.dart';

/// Phone numbers are sent as the person typed them; the backend normalises
/// them. Every login sends the device's `fcm_token` and `platform`.
class AuthService {
  //!==================== Residents: login ====================

  /// Texts a login code: first login of an account created by staff, and
  /// "Forgot password?". Never sent on a normal login.
  static Future<ApiResult<OtpSent>> requestLoginOtp({required String phone}) =>
      _post(ApiPaths.loginOtp, {'phone': phone}, parse: OtpSent.fromJson);

  /// Checks the code; returns the password `setup_token`.
  static Future<ApiResult<VerifiedToken>> verifyLoginOtp({
    required String phone,
    required String code,
  }) => _post(
    ApiPaths.loginOtpVerify,
    {'phone': phone, 'code': code},
    parse: (data) => VerifiedToken.fromJson(data, 'setup_token')!,
  );

  /// Sets the password with the [setupToken] and logs in. Signs out every
  /// other device.
  static Future<ApiResult<LoginData>> setPassword({
    required String setupToken,
    required String password,
    required String passwordConfirmation,
    String? fcmToken,
    required String platform,
  }) => _post(
    ApiPaths.setPassword,
    {
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (fcmToken != null) 'fcm_token': fcmToken,
      'platform': platform,
    },
    headers: {'Authorization': 'Bearer $setupToken'},
    parse: LoginData.fromJson,
  );

  /// One login for everyone: [login] is a phone number (residents) or an
  /// email (security staff). Never sends an SMS.
  static Future<ApiResult<LoginData>> login({
    required String login,
    required String password,
    String? fcmToken,
    required String platform,
  }) => _post(ApiPaths.authLogin, {
    'login': login,
    'password': password,
    if (fcmToken != null) 'fcm_token': fcmToken,
    'platform': platform,
  }, parse: LoginData.fromJson);

  //!==================== Residents: registration ====================

  /// [locale] is the language of the SMS.
  static Future<ApiResult<OtpSent>> requestRegisterOtp({
    required String phone,
    required String locale,
  }) => _post(ApiPaths.registerOtp, {
    'phone': phone,
    'locale': locale,
  }, parse: OtpSent.fromJson);

  /// Returns the `registration_token` (30 minutes, used once).
  static Future<ApiResult<VerifiedToken>> verifyRegisterOtp({
    required String phone,
    required String code,
  }) => _post(
    ApiPaths.registerVerify,
    {'phone': phone, 'code': code},
    parse: (data) => VerifiedToken.fromJson(data, 'registration_token')!,
  );

  /// `201` puts the account in review; it is not a login. [unitCodes]: 1 to
  /// 10 codes, not checked here (staff check each one). After approval the
  /// resident logs in with phone + [password], no code.
  static Future<ApiResult<void>> register({
    required String registrationToken,
    required String name,
    String? email,
    required List<String> unitCodes,
    required String password,
    required String passwordConfirmation,
    required String locale,
  }) => _post(ApiPaths.register, {
    'registration_token': registrationToken,
    'name': name,
    if (email != null) 'email': email,
    'unit_codes': unitCodes,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'locale': locale,
  });

  //!=========== Security staff: the email password reset ===========

  static Future<ResetOrForgetPasswordResponseModel> forgetPassword({
    required String email,
  }) async {
    final forgetPassword = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.forgetPassword,
      data: {"email": email},
    );
    try {
      if (forgetPassword != null &&
          forgetPassword.statusCode == 200 &&
          forgetPassword.data != null) {
        return ResetOrForgetPasswordResponseModel.fromJson(forgetPassword.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While forget Password: $e\n$st');
    }
    return ResetOrForgetPasswordResponseModel.fromJson(forgetPassword?.data);
  }

  static Future<ResetOrForgetPasswordResponseModel> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  }) async {
    final resetPassword = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.resetPassword,
      data: resetPasswordRequestModel.toJson(),
    );
    try {
      if (resetPassword != null &&
          resetPassword.statusCode == 200 &&
          resetPassword.data != null) {
        return ResetOrForgetPasswordResponseModel.fromJson(resetPassword.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While reset Password: $e\n$st');
    }
    return ResetOrForgetPasswordResponseModel.fromJson(resetPassword?.data);
  }

  static Future<OtpVerificationResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final verifyOtp = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.verifyOtp,
      data: {"email": email, "otp_code": otpCode},
    );
    try {
      if (verifyOtp != null &&
          verifyOtp.statusCode == 200 &&
          verifyOtp.data != null) {
        return OtpVerificationResponse.fromJson(verifyOtp.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While verify Otp: $e\n$st');
    }
    return OtpVerificationResponse.fromJson(verifyOtp?.data);
  }

  //!==================== Everyone ====================

  /// Logs out this device and stops its pushes. Other devices stay in.
  static Future<GeneralResponseModel> logOut() async {
    final responseLogOut = await DioHelper.postData(
      needHeader: true,
      path: ApiPaths.logOut,
    );
    try {
      AppLogger.info('responseLogOut==> ${responseLogOut?.statusCode}');
      if (responseLogOut != null &&
          responseLogOut.statusCode == 200 &&
          responseLogOut.data != null &&
          responseLogOut.data['success'] == true) {
        return GeneralResponseModel.fromJson(responseLogOut.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While Log Out: $e\n$st');
    }
    return GeneralResponseModel.fromJson(responseLogOut?.data ?? {});
  }

  static Future<ApiResult<T>> _post<T>(
    String path,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic> data)? parse,
  }) => apiRequest<T>(
    'POST $path',
    () => DioHelper.postData(
      path: path,
      data: body,
      needHeader: false,
      headers: {'Accept': 'application/json', ...?headers},
    ),
    parse: parse,
  );
}
