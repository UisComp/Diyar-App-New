abstract class VisitorState {}
class VisitorInitial extends VisitorState {}
class PickDateRangeLoadingState extends VisitorState {}
class PickDateRangeSelected extends VisitorState {}
class PickDateRangeCancelled extends VisitorState {}
class PickDateRangeError extends VisitorState {
  final String? message;
  PickDateRangeError({this.message});
}
class PickStartTimeLoading extends VisitorState {}
class PickStartTimeSelected extends VisitorState {}
class PickStartTimeCancelled extends VisitorState {}
class PickStartTimeError extends VisitorState {
  final String? message;
  PickStartTimeError({this.message});
}
class PickEndTimeLoading extends VisitorState {}
class PickEndTimeSelected extends VisitorState {}
class PickEndTimeCancelled extends VisitorState {}
class PickEndTimeError extends VisitorState {
  final String? message;
  PickEndTimeError({this.message});
}
class GeneratingQrState extends VisitorState {}
class EmptyQrState extends VisitorState {
  final String message;
  EmptyQrState(this.message);
}
class QrGeneratedState extends VisitorState {}
class UnitChangedState  extends VisitorState {}
class ClearDataState extends VisitorState {}
class StartScanState extends VisitorState {}
class StopScanState extends VisitorState {}