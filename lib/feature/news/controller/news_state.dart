abstract class NewsState {}

class NewsInitial extends NewsState {}

class GetAllNewsLoadingState extends NewsState {}

class GetAllNewsSuccessfullyState extends NewsState {}

class GetAllNewsErrorState extends NewsState {
  final String? error;
  GetAllNewsErrorState({this.error});
}
