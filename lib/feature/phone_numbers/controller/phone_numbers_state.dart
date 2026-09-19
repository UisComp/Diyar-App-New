import 'package:diyar_app/core/model/api_result.dart';

abstract class PhoneNumbersState {}

class PhoneNumbersInitialState extends PhoneNumbersState {}

class PhoneNumbersLoadingState extends PhoneNumbersState {}

class PhoneNumbersLoadedState extends PhoneNumbersState {}

class PhoneNumbersLoadFailureState extends PhoneNumbersState {
  PhoneNumbersLoadFailureState(this.result);

  final ApiResult<dynamic> result;
}

/// Making a number primary, removing one, or cancelling a request.
class PhoneNumbersActionLoadingState extends PhoneNumbersState {}

enum PhoneNumbersAction { madePrimary, removalRequested, requestCancelled }

class PhoneNumbersActionSuccessState extends PhoneNumbersState {
  PhoneNumbersActionSuccessState(this.action);

  final PhoneNumbersAction action;
}

class PhoneNumbersActionFailureState extends PhoneNumbersState {
  PhoneNumbersActionFailureState(this.result);

  final ApiResult<dynamic> result;
}
