import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/model/api_result.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

/// A unit row was added or removed.
class RegisterUnitsChangedState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

/// Registration received: the account waits for staff approval.
class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  RegisterFailureState(this.result);

  final ApiResult<dynamic> result;

  /// The registration token expired or was used: verify the number again.
  bool get mustVerifyAgain =>
      result.errorCode == ApiErrorCodes.registrationTokenInvalid;
}
