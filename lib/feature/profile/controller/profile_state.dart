import 'package:diyar_app/feature/profile/model/unit_model_details_for_linked_user.dart';

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

class PickingImageProfileLoadingState extends ProfileState {}

class GetUnitsForUserLinkedLoadingState extends ProfileState {}

class GetUnitsForUserLinkedSuccessfullyState extends ProfileState {
  final UnitModelDetailsForLinkedUserResponseModel? data;

  GetUnitsForUserLinkedSuccessfullyState({this.data});
}

class GetUnitsForUserLinkedFailureState extends ProfileState {}
