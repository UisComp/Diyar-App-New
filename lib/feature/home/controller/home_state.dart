abstract class HomeState{}
class HomeInitial extends HomeState{}
class ChangeIndexBottomNavBarState extends HomeState{}
class GetAllServicesLoadingState extends HomeState{}
class GetAllServicesSuccessfullyState extends HomeState{}
class GetAllServicesErrorState extends HomeState{
  final String ?error; 
  GetAllServicesErrorState({this.error});
}
class FilteredServicesState extends HomeState{}