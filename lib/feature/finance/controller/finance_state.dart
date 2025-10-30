// abstract class FinanceState {}

// class FinanceInitial extends FinanceState {}
// class FinanceLoadingState extends FinanceState {}
// class FinanceSuccessState extends FinanceState {}
// class FinanceFailureState extends FinanceState {
//   final String? errorMessage;

//   FinanceFailureState({this.errorMessage});
// }
// class PriviewFileLoadingState extends FinanceState {}
// class PriviewFileSuccessState extends FinanceState {}
// class PriviewFileFailureState extends FinanceState {
//   final String? errorMessage;

//   PriviewFileFailureState({this.errorMessage});
// }
// class DownloadFileLoadingState extends FinanceState {}
// class DownloadFileSuccessState extends FinanceState {}
// class DownloadFileFailureState extends FinanceState {
//   final String? errorMessage;

//   DownloadFileFailureState({this.errorMessage});
// }

import 'package:freezed_annotation/freezed_annotation.dart';
part 'finance_state.freezed.dart';

@freezed
class FinanceState with _$FinanceState {
  const factory FinanceState.initial() = _Initial;
  const factory FinanceState.loading() = _Loading;
  const factory FinanceState.success() = _Success;
  const factory FinanceState.failure({String? errorMessage}) = _Failure;

  const factory FinanceState.previewFileLoading() = _PreviewFileLoading;
  const factory FinanceState.previewFileSuccess() = _PreviewFileSuccess;
  const factory FinanceState.previewFileFailure({String? errorMessage}) =
      _PreviewFileFailure;

  const factory FinanceState.downloadFileLoading() = _DownloadFileLoading;
  const factory FinanceState.downloadFileSuccess() = _DownloadFileSuccess;
  const factory FinanceState.downloadFileFailure({String? errorMessage}) =
      _DownloadFileFailure;

  const factory FinanceState.getFinanceLoading() = _GetFinanceLoading;
  const factory FinanceState.getFinanceSuccess() = _GetFinanceSuccess;
  const factory FinanceState.getFinanceFailure({String? errorMessage}) =
      _GetFinanceFailure;
  const factory FinanceState.getDocumentsLoading() = _GetDocumentsLoading;
  const factory FinanceState.getDocumentsSuccess() = _GetDocumentsSuccess;
  const factory FinanceState.getDocumentsFailure({String? errorMessage}) =
      _GetDocumentsFailure;
}
