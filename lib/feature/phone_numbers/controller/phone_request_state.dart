import 'package:diyar_app/core/model/api_result.dart';

abstract class PhoneRequestState {}

class PhoneRequestInitialState extends PhoneRequestState {}

class PhoneRequestSendingCodeState extends PhoneRequestState {}

class PhoneRequestCodeSentState extends PhoneRequestState {}

class PhoneRequestTickState extends PhoneRequestState {
  PhoneRequestTickState(this.resendIn);

  final int resendIn;
}

class PhoneRequestSubmittingState extends PhoneRequestState {}

/// Sent to staff for review.
class PhoneRequestSubmittedState extends PhoneRequestState {}

class PhoneRequestFailureState extends PhoneRequestState {
  PhoneRequestFailureState(this.result);

  final ApiResult<dynamic> result;
}
