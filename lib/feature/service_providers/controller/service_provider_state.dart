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
class ServiceProviderRefreshState extends ServiceProviderState {}