abstract class ServiceProviderState {}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoadingState extends ServiceProviderState {}

class ServiceProviderSuccessState extends ServiceProviderState {}

class ServiceProviderFailureState extends ServiceProviderState {
  final String? errorMessage;

  ServiceProviderFailureState({this.errorMessage});
}

class CreateServiceProviderLoadingState extends ServiceProviderState {}

class CreateServiceProviderSuccessState extends ServiceProviderState {}

class CreateServiceProviderFailureState extends ServiceProviderState {
  final String? errorMessage;

  CreateServiceProviderFailureState({this.errorMessage});
}

/// The server refused the whole request with a `422` — **no** booking was
/// created. Usually one of the chosen providers stopped taking bookings
/// after the list was fetched, so the list is re-fetched right after this.
class CreateServiceProviderRejectedState extends ServiceProviderState {
  final String? errorMessage;

  CreateServiceProviderRejectedState({this.errorMessage});
}

class ServiceProviderRefreshState extends ServiceProviderState {}

class ServiceProviderHistoryLoadingState extends ServiceProviderState {}

class ServiceProviderHistorySuccessState extends ServiceProviderState {}

class ServiceProviderHistoryFailureState extends ServiceProviderState {
  final String? errorMessage;

  ServiceProviderHistoryFailureState({this.errorMessage});
}
