abstract class AuthState {}

class AuthInitialState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginFailureState extends AuthState {
  final String? error;

  LoginFailureState({this.error});
}

class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {}

class RegisterFailureState extends AuthState {
  final String? error;

  RegisterFailureState({this.error});
}

class ForgetPasswordLoadingState extends AuthState {}

class ForgetPasswordSuccessState extends AuthState {}

class ForgetPasswordFailureState extends AuthState {
  final String? error;

  ForgetPasswordFailureState({this.error});
}

class StartingTimerState extends AuthState {}

class StoppingTimerState extends AuthState {}

class TimerFinishedState extends AuthState {}

class TimerTickState extends AuthState {
  final int remainingSeconds;

  TimerTickState(this.remainingSeconds);
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordFailureState extends AuthState {
  final String? error;

  ResetPasswordFailureState({this.error});
}

class VerifyOtpSuccessState extends AuthState {}

class VerifyOtpFailureState extends AuthState {
  final String? error;

  VerifyOtpFailureState({this.error});
}

class VerifyOtpLoadingState extends AuthState {}
