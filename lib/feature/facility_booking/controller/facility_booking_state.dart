abstract class FacilityBookingState {}

class FacilityBookingInitial extends FacilityBookingState {}

class FacilityBookingLoadingState extends FacilityBookingState {}

class FacilityBookingSuccessState extends FacilityBookingState {}

class FacilityBookingFailureState extends FacilityBookingState {
  final String? errorMessage;
  FacilityBookingFailureState({this.errorMessage});
}
