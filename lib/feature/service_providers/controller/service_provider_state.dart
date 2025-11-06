abstract class ServiceProviderState {}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoadingState extends ServiceProviderState {}

class ServiceProviderSuccessState extends ServiceProviderState {}

class ServiceProviderFailureState extends ServiceProviderState {
  final String? errorMessage;

  ServiceProviderFailureState({this.errorMessage});
}
