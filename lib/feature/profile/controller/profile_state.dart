abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class GetMyProfileLoadingState extends ProfileState {}

class GetMyProfileSuccessState extends ProfileState {}

class GetMyProfileFailureState extends ProfileState {}

class PickingImageProfileSuccessfully extends ProfileState {}

class EmptyImageProfileState extends ProfileState {}

class PickingImageProfileFailureState extends ProfileState {
  final String? error;

  PickingImageProfileFailureState({this.error});
}

class EditingProfileLoadingState extends ProfileState {}

class EditingProfileSuccessfullyState extends ProfileState {}

class EditingProfileFailureState extends ProfileState {
  final String? error;

  EditingProfileFailureState({this.error});
}

class GetUserLinkedUnitsLoadingState extends ProfileState {}

class GetUserLinkedUnitsSuccessfullyState extends ProfileState {}

class GetUserLinkedUnitsFailureState extends ProfileState {
  final String? error;

  GetUserLinkedUnitsFailureState({this.error});
}
class PickingImageProfileLoadingState  extends ProfileState {}