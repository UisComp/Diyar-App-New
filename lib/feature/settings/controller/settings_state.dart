abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class ChangePasswordLoadingState extends SettingsState {}

class ChangePasswordSuccessfullyState extends SettingsState {}

class ChangePasswordFailureState extends SettingsState {
  final String? error;

  ChangePasswordFailureState({this.error});
}

class BiometricLoading extends SettingsState {}

class BiometricEnabled extends SettingsState {}

class BiometricDisabled extends SettingsState {}

class BiometricNotSupported extends SettingsState {}

class BiometricLockNotSet extends SettingsState {}

class BiometricError extends SettingsState {
  final String error;
  BiometricError(this.error);
}

class DeleteAccountLoadingState extends SettingsState {}

class DeleteAccountSuccessfullyState extends SettingsState {}

class DeleteAccountFailureState extends SettingsState {
  final String? error;

  DeleteAccountFailureState({this.error});
}

class GetConfigDataLoadingState extends SettingsState {}

class GetConfigDataSuccessfullyState extends SettingsState {}

class GetConfigDataFailureState extends SettingsState {
  final String? error;

  GetConfigDataFailureState({this.error});
}

class SendEmailLoadingState extends SettingsState {}

class SendEmailSuccessfullyState extends SettingsState {}

class SendEmailFailureState extends SettingsState {
  final String? error;

  SendEmailFailureState({this.error});
}

class EnableEmailNotificationState extends SettingsState {}
class DisableEmailNotificationState extends SettingsState {}
class DisableNotificationState  extends SettingsState {}
class EnableNotificationState extends SettingsState {}
