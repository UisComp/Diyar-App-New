import 'dart:async';

import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/helper/sms_code_retriever.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/feature/auth/controller/otp_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The SMS code step of the first login, "Forgot password?" and
/// registration. Codes are 6 digits and last 5 minutes; a resend unlocks
/// after the server's `resend_in` (or `retry_after`) seconds.
class OtpController extends Cubit<OtpState> {
  OtpController({required this.args, this.locale = 'ar'})
    : super(OtpInitialState());

  static OtpController get(BuildContext context) => BlocProvider.of(context);

  static const codeLength = 6;

  final OtpArgs args;

  /// Language of the registration SMS.
  final String locale;

  final codeController = TextEditingController();

  Timer? _timer;
  int _resendIn = 0;

  /// Seconds until a new code can be requested.
  int get resendIn => _resendIn;

  bool get canResend =>
      _resendIn == 0 &&
      state is! OtpSendingState &&
      state is! OtpVerifyingState;

  /// A code went out at least once, so the code field is useful.
  bool codeSent = false;

  bool get _isRegistration => args.purpose == OtpPurpose.register;

  /// Texts a code. Called when the screen opens and on "Resend".
  Future<void> sendCode() async {
    if (state is OtpSendingState || state is OtpVerifyingState) return;
    emit(OtpSendingState());
    final result = _isRegistration
        ? await AuthService.requestRegisterOtp(
            phone: args.phone,
            locale: locale,
          )
        : await AuthService.requestLoginOtp(phone: args.phone);
    if (isClosed) return;

    if (result.success) {
      codeSent = true;
      codeController.clear();
      _startCountdown(result.data!.resendIn);
      emit(OtpSentState());
      _listenForSms();
    } else {
      // resend_wait / too_many: lock the button for as long as we're told.
      if (result.retryAfter != null) _startCountdown(result.retryAfter!);
      emit(OtpSendFailureState(result));
    }
  }

  /// Checks the typed code.
  Future<void> verify() async {
    final code = codeController.text.trim();
    if (code.length != codeLength || state is OtpVerifyingState) return;
    emit(OtpVerifyingState());
    final ApiResult<VerifiedToken> result = _isRegistration
        ? await AuthService.verifyRegisterOtp(phone: args.phone, code: code)
        : await AuthService.verifyLoginOtp(phone: args.phone, code: code);
    if (isClosed) return;

    if (result.success) {
      _timer?.cancel();
      unawaited(SmsCodeRetriever.stop());
      emit(OtpVerifiedState(result.data!.token));
      return;
    }
    if (result.errorCode == ApiErrorCodes.invalid ||
        ApiErrorCodes.isDeadCode(result.errorCode)) {
      codeController.clear();
    }
    // After 5 wrong tries, or once the code expired, only a new code helps:
    // let the resident ask for it straight away.
    if (ApiErrorCodes.isDeadCode(result.errorCode)) {
      _timer?.cancel();
      _resendIn = 0;
    }
    emit(OtpVerifyFailureState(result));
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    _resendIn = seconds < 0 ? 0 : seconds;
    if (_resendIn == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      _resendIn = _resendIn > 0 ? _resendIn - 1 : 0;
      if (_resendIn == 0) timer.cancel();
      emit(OtpTickState(_resendIn));
    });
  }

  /// Android: fills in and submits the code from the SMS.
  void _listenForSms() {
    unawaited(
      SmsCodeRetriever.stop()
          .then((_) => SmsCodeRetriever.listen())
          .then((code) {
            if (isClosed || code == null || code.length != codeLength) return;
            if (state is OtpVerifyingState || state is OtpVerifiedState) return;
            codeController.text = code;
            verify();
          })
          .catchError((_) {}),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    unawaited(SmsCodeRetriever.stop().catchError((_) {}));
    codeController.dispose();
    return super.close();
  }
}
