abstract class NewsState {}

class NewsInitial extends NewsState {}

class GetAllNewsLoadingState extends NewsState {}

class GetAllNewsSuccessfullyState extends NewsState {}

class GetAllNewsErrorState extends NewsState {
  final String? error;
  GetAllNewsErrorState({this.error});
}
class  GetNewsDetailsLoadingState extends NewsState{}

class  GetNewsDetailsSuccessfullyState extends NewsState{}
class  GetNewsDetailsErrorState extends NewsState{
  final String? error;
  GetNewsDetailsErrorState({this.error});
}
class ChangeCarouselIndexState extends NewsState{}