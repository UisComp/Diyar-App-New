abstract class FacilityBookingState {}

class FacilityBookingInitial extends FacilityBookingState {}

class FacilityBookingLoadingState extends FacilityBookingState {}

class FacilityBookingSuccessState extends FacilityBookingState {}

class FacilityBookingFailureState extends FacilityBookingState {
  final String? errorMessage;
  FacilityBookingFailureState({this.errorMessage});
}
class FacilityBookingSelectionUpdated extends FacilityBookingState {}
class SelectAllFacilityBookingState extends FacilityBookingState {}
class CreateFacilityRequestLoadingState extends FacilityBookingState {}
class CreateFacilityRequestSuccessState extends FacilityBookingState {}
class CreateFacilityRequestFailureState extends FacilityBookingState {
  final String? errorMessage;
  CreateFacilityRequestFailureState({this.errorMessage});
}
class PleaseSelectYourFacilityState extends FacilityBookingState {}
