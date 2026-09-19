import 'dart:async';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_or_forget_password_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_password_request_model.dart';
import 'package:diyar_app/feature/auth/model/verify_otp_response_model.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The email password reset of security staff, and logging anyone out.
/// Signing in is [LoginController]'s job.
class AuthController extends Cubit<AuthState> {
  AuthController() : super(AuthInitialState());
  static AuthController get(BuildContext context) => BlocProvider.of(context);
  final TextEditingController emailForForgetPasswordController =
      TextEditingController();
  //!==================================Reset Password Controller=========================================
  final TextEditingController passwordControllerForResetPassword =
      TextEditingController();
  final TextEditingController passwordConfirmationControllerForResetPassword =
      TextEditingController();
  //!============================================================================
  ResetOrForgetPasswordResponseModel forgetPasswordResponseModel =
      ResetOrForgetPasswordResponseModel();
  OtpVerificationResponse otpVerifyResponseModel = OtpVerificationResponse();
  ResetOrForgetPasswordResponseModel resetOrForgetPasswordResponseModel =
      ResetOrForgetPasswordResponseModel();
  TextEditingController otpController = TextEditingController();
  GeneralResponseModel logoutResponseModel = GeneralResponseModel();
  Future<void> forgetPassword() async {
    emit(ForgetPasswordLoadingState());
    await AuthService.forgetPassword(
          email: emailForForgetPasswordController.text,
        )
        .then((value) async {
          await saveEmail(emailForForgetPasswordController.text);
          forgetPasswordResponseModel = value;
          AppLogger.success(
            'forgetPasswordResponseModel: $forgetPasswordResponseModel',
          );
          if (value.success == true) {
            emit(ForgetPasswordSuccessState());
            clearEmailForForgetPassword();
          } else {
            emit(ForgetPasswordFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While Forget Password is ${error.toString()}',
          );
          emit(ForgetPasswordFailureState(error: error.toString()));
        });
  }

  void clearEmailForForgetPassword() {
    emailForForgetPasswordController.clear();
    emailForForgetPasswordController.text = '';
  }

  Future<void> resendOtp() async {
    if (savedEmailForForgetPasword == null ||
        savedEmailForForgetPasword!.isEmpty) {
      emit(ResendOtpFailureState(error: "Missing email for resend."));
      return;
    }
    emit(ResendOtpLoadingState());
    try {
      final value = await AuthService.forgetPassword(
        email: savedEmailForForgetPasword!,
      );
      if (value.success == true) {
        await saveRefreshToken(value.data?.refreshToken);
        await startTimer();
        emit(ResendOtpSuccessState());
      } else {
        emit(ResendOtpFailureState(error: value.message));
      }
    } catch (e) {
      emit(ResendOtpFailureState(error: e.toString()));
    }
  }

  Timer? timer;
  int remainingSeconds = 30;
  String get minutes => (remainingSeconds ~/ 60).toString().padLeft(2, '0');
  String get seconds => (remainingSeconds % 60).toString().padLeft(2, '0');
  Future<void> initTimer() async {
    startTimer();
    emit(StartingTimerState());
  }

  Future<void> stopTimer() async {
    timer?.cancel();
    emit(StoppingTimerState());
  }

  Future<void> startTimer() async {
    remainingSeconds = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        emit(TimerFinishedState());
      } else {
        remainingSeconds--;
        emit(TimerTickState(remainingSeconds));
      }
    });
  }

  Future<void> resetPassword() async {
    emit(ResetPasswordLoadingState());
    await AuthService.resetPassword(
          resetPasswordRequestModel: ResetPasswordRequestModel(
            email:
                savedEmailForForgetPasword ??
                emailForForgetPasswordController.text,
            token: savedRefreshToken ?? otpVerifyResponseModel.data?.resetToken,
            password: passwordControllerForResetPassword.text,
            passwordConfirmation:
                passwordConfirmationControllerForResetPassword.text,
          ),
        )
        .then((value) async {
          resetOrForgetPasswordResponseModel = value;
          if (value.success == true) {
            emit(ResetPasswordSuccessState());
            await saveRefreshToken(null);
            await saveEmail(null);
          } else {
            emit(ResetPasswordFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Reset Password is $error');
          emit(ResetPasswordFailureState(error: error.toString()));
        });
  }

  Future<void> verifyOtp() async {
    emit(VerifyOtpLoadingState());
    await AuthService.verifyOtp(
          email:
              savedEmailForForgetPasword ??
              emailForForgetPasswordController.text,
          otpCode: otpController.text,
        )
        .then((value) async {
          otpVerifyResponseModel = value;
          if (value.success == true) {
            await saveRefreshToken(value.data?.resetToken);
            emit(VerifyOtpSuccessState());
          } else {
            emit(VerifyOtpFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Verify Otp is $error');
          emit(VerifyOtpFailureState(error: error.toString()));
        });
  }

  /// Logs this device out. The local session is cleared even if the
  /// request fails, so the device never keeps a half-valid login.
  Future<void> logOut() async {
    if (state is LogOutLoadingState) return;
    emit(LogOutLoadingState());
    GeneralResponseModel? response;
    try {
      response = await AuthService.logOut();
    } catch (error) {
      AppLogger.error('Error Happen While log out is $error');
    }
    logoutResponseModel = response ?? GeneralResponseModel();
    await AuthSession.clear();
    if (isClosed) return;
    emit(
      response?.success == true
          ? LogOutSuccessState()
          : LogOutFailureState(error: response?.message),
    );
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
