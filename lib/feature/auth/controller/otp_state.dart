import 'package:diyar_app/core/model/api_result.dart';

abstract class OtpState {}

class OtpInitialState extends OtpState {}

class OtpSendingState extends OtpState {}

class OtpSentState extends OtpState {}

class OtpSendFailureState extends OtpState {
  OtpSendFailureState(this.result);

  final ApiResult<dynamic> result;
}

/// The resend countdown moved.
class OtpTickState extends OtpState {
  OtpTickState(this.resendIn);

  final int resendIn;
}

class OtpVerifyingState extends OtpState {}

class OtpVerifiedState extends OtpState {
  OtpVerifiedState(this.token);

  /// `setup_token` (login, reset) or `registration_token` (register).
  final String token;
}

class OtpVerifyFailureState extends OtpState {
  OtpVerifyFailureState(this.result);

  final ApiResult<dynamic> result;
}
