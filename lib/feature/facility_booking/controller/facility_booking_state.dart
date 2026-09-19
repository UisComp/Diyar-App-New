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

/// The server refused the whole request with a `422` — **no** booking was
/// created. Usually a chosen facility stopped taking bookings after the list
/// was fetched, so the list is re-fetched right after this.
class CreateFacilityRequestRejectedState extends FacilityBookingState {
  final String? errorMessage;
  CreateFacilityRequestRejectedState({this.errorMessage});
}

/// The resident tapped a facility that isn't taking bookings.
class FacilityNotBookableState extends FacilityBookingState {}

class PleaseSelectYourFacilityState extends FacilityBookingState {}

class FacilityBookingHistoryLoadingState extends FacilityBookingState {}

class FacilityBookingHistorySuccessState extends FacilityBookingState {}

class FacilityBookingHistoryFailureState extends FacilityBookingState {
  final String? errorMessage;
  FacilityBookingHistoryFailureState({this.errorMessage});
}

class FacilityBookingRefreshState extends FacilityBookingState {}
