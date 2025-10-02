import 'dart:async';
import 'dart:developer';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/model/register_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_or_forget_password_response_model.dart';
import 'package:diyar_app/feature/auth/model/reset_password_request_model.dart';
import 'package:diyar_app/feature/auth/model/verify_otp_response_model.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

class AuthController extends Cubit<AuthState> {
  AuthController() : super(AuthInitialState());
  static AuthController get(BuildContext context) => BlocProvider.of(context);
  //! login
  TextEditingController emailControllerForLogin = TextEditingController();
  TextEditingController passwordControllerForLogin = TextEditingController();
  //!=============================================================================
  //! Register
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailControllerForRegister =
      TextEditingController();
  final TextEditingController passwordControllerForRegister =
      TextEditingController();
  final TextEditingController passwordConfirmationControllerForRegister =
      TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  //!==========================================================================

  final TextEditingController emailForForgetPasswordController =
      TextEditingController();
  //!==================================Reset Password Controller=========================================
  final TextEditingController passwordControllerForResetPassword =
      TextEditingController();
  final TextEditingController passwordConfirmationControllerForResetPassword =
      TextEditingController();
  //!============================================================================
  LoginResponseModel loginResponseModel = LoginResponseModel();
  RegisterResponseModel registerResponseModel = RegisterResponseModel();

  ResetOrForgetPasswordResponseModel forgetPasswordResponseModel =
      ResetOrForgetPasswordResponseModel();
  OtpVerificationResponse otpVerifyResponseModel = OtpVerificationResponse();
  ResetOrForgetPasswordResponseModel resetOrForgetPasswordResponseModel =
      ResetOrForgetPasswordResponseModel();
  TextEditingController otpController = TextEditingController();
  final phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
  );
  GeneralResponseModel logoutResponseModel = GeneralResponseModel();
  void initController() {
    emailControllerForLogin.clear();
    passwordControllerForLogin.clear();
  }

  Future<void> login() async {
    emit(LoginLoadingState());
    await AuthService.login(
          authRequestModel: RequestModel(
            email: emailControllerForLogin.text,
            password: passwordControllerForLogin.text,
          ),
        )
        .then((value) async {
          loginResponseModel = value;
          if (value.success == true) {
            emit(LoginSuccessState());
            await updateUserModel(value);
            await HiveHelper.storeUserModel(value, AppConstants.userModelKey);
          } else {
            emit(LoginFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Login is $error');
          emit(LoginFailureState(error: error.toString()));
        });
  }

  Future<void> register() async {
    emit(RegisterLoadingState());
    await AuthService.register(
          authRequestModel: RequestModel(
            phoneNumber: phoneController.value.international,
            passwordConfirmation:
                passwordConfirmationControllerForRegister.text,
            name: nameController.text,
            email: emailControllerForRegister.text,
            password: passwordControllerForRegister.text,
          ),
        )
        .then((value) {
          registerResponseModel = value;
          if (value.success == true) {
            emit(RegisterSuccessState());
          } else {
            emit(RegisterFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Register is $error');
          emit(RegisterFailureState(error: error.toString()));
        });
  }

  Future<void> forgetPassword() async {
    emit(ForgetPasswordLoadingState());
    await AuthService.forgetPassword(
          email: emailForForgetPasswordController.text,
        )
        .then((value) {
          forgetPasswordResponseModel = value;
          log('forgetPasswordResponseModel: $forgetPasswordResponseModel');
          if (value.success == true) {
            emit(ForgetPasswordSuccessState());
          } else {
            emit(ForgetPasswordFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Forget Password is ${error.toString()}');
          emit(ForgetPasswordFailureState(error: error.toString()));
        });
  }

  late Timer timer;
  int remainingSeconds = 30;
  String get minutes => (remainingSeconds ~/ 60).toString().padLeft(2, '0');
  String get seconds => (remainingSeconds % 60).toString().padLeft(2, '0');
  Future<void> initTimer() async {
    startTimer();
    emit(StartingTimerState());
  }

  Future<void> stopTimer() async {
    timer.cancel();
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
            email: emailForForgetPasswordController.text,
            token: otpVerifyResponseModel.data?.resetToken,
            password: passwordControllerForResetPassword.text,
            passwordConfirmation:
                passwordConfirmationControllerForResetPassword.text,
          ),
        )
        .then((value) {
          resetOrForgetPasswordResponseModel = value;
          emit(ResetPasswordSuccessState());
        })
        .catchError((error) {
          log('Error Happen While Reset Password is $error');
          emit(ResetPasswordFailureState(error: error.toString()));
        });
  }

  Future<void> verifyOtp() async {
    emit(VerifyOtpLoadingState());
    await AuthService.verifyOtp(
          email: emailForForgetPasswordController.text,
          otpCode: otpController.text,
        )
        .then((value) {
          otpVerifyResponseModel = value;
          emit(VerifyOtpSuccessState());
        })
        .catchError((error) {
          log('Error Happen While Verify Otp is $error');
          emit(VerifyOtpFailureState(error: error.toString()));
        });
  }

  Future<void> logOut() async {
    emit(LogOutLoadingState());
    await AuthService.logOut()
        .then((value) async {
          logoutResponseModel = value;
          if (value.success == true) {
            emit(LogOutSuccessState());
            await updateUserModel(null);
            await HiveHelper.clearAllData();
          } else {
            emit(LogOutFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While log out is $error');
          emit(LoginFailureState(error: error.toString()));
        });
  }
}
