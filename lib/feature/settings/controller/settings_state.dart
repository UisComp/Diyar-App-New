abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class ChangePasswordLoadingState extends SettingsState {}

class ChangePasswordSuccessfullyState extends SettingsState {}

class ChangePasswordFailureState extends SettingsState {
  final String? error;

  ChangePasswordFailureState({this.error});
}
