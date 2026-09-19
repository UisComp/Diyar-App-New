import 'package:diyar_app/core/model/api_result.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

/// Switched between the phone and the email field.
class LoginModeChangedState extends LoginState {}

class SignInLoadingState extends LoginState {}

class SignInSuccessState extends LoginState {}

class SignInFailureState extends LoginState {
  SignInFailureState(
    this.result, {
    this.phone,
    this.savedLoginOutdated = false,
  });

  final ApiResult<dynamic> result;

  /// The phone number used, when it was one (e.g. to text a code for
  /// `password_not_set`).
  final String? phone;

  /// Biometric sign-in used credentials that no longer work; they were
  /// forgotten.
  final bool savedLoginOutdated;
}

/// Biometric sign-in found nothing saved.
class NoSavedLoginState extends LoginState {}
