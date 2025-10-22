import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/model/register_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_or_forget_password_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_password_request_model.dart';
import 'package:diyar_app/feature/auth/model/verify_otp_response_model.dart';

class AuthService {
  static Future<LoginResponseModel> login({
    required RequestModel authRequestModel,
  }) async {
    final response = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.login,
      data: authRequestModel.toJson(),
    );
    try {
      AppLogger.info('loginResponse==> ${response?.data}');
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null &&
          response.data['success'] == true) {
        return LoginResponseModel.fromJson(response.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While Login: $e\n$st');
    }
    return LoginResponseModel.fromJson(response?.data);
  }

  static Future<RegisterResponseModel> register({
    required RequestModel authRequestModel,
  }) async {
    final response = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.register,
      data: authRequestModel.toJson(),
    );
    try {
      AppLogger.info('registerResponse==> ${response?.data}');
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        return RegisterResponseModel.fromJson(response.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While Register: $e\n$st');
    }
    return RegisterResponseModel.fromJson(response?.data);
  }

  static Future<ResetOrForgetPasswordResponseModel> forgetPassword({
    required String email,
  }) async {
    final forgetPassword = await DioHelper.postData(
      needHeader: false,
      path: ApiPaths.forgetPassword,
      data: {"email": email},
    );
    try {
      AppLogger.info('forgetPassword==> ${forgetPassword?.data}');
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
      AppLogger.info('resetPassword==> ${resetPassword?.data}');
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
      AppLogger.info('verifyOtp==> ${verifyOtp?.data}');
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

 static Future<GeneralResponseModel> logOut() async {
    final responseLogOut = await DioHelper.postData(
      needHeader: true,
      path: ApiPaths.logOut,
    );
    try {
      AppLogger.info('responseLogOut==> ${responseLogOut?.data}');
      if (responseLogOut != null &&
          responseLogOut.statusCode == 200 &&
          responseLogOut.data != null &&
          responseLogOut.data['success'] == true) {
        return GeneralResponseModel.fromJson(responseLogOut.data);
      }
    } catch (e, st) {
      AppLogger.error('Error While Log Out: $e\n$st');
    }
    return GeneralResponseModel.fromJson(responseLogOut?.data);
  }
}
