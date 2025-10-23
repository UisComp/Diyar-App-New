abstract class FinanceState {}

class FinanceInitial extends FinanceState {}
class FinanceLoadingState extends FinanceState {}
class FinanceSuccessState extends FinanceState {}
class FinanceFailureState extends FinanceState {
  final String? errorMessage;

  FinanceFailureState({this.errorMessage});
}
class PriviewFileLoadingState extends FinanceState {}
class PriviewFileSuccessState extends FinanceState {}
class PriviewFileFailureState extends FinanceState {
  final String? errorMessage;

  PriviewFileFailureState({this.errorMessage});
}
class DownloadFileLoadingState extends FinanceState {}
class DownloadFileSuccessState extends FinanceState {}
class DownloadFileFailureState extends FinanceState {
  final String? errorMessage;

  DownloadFileFailureState({this.errorMessage});
}
