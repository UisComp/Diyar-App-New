import 'package:diyar_app/core/model/api_result.dart';

abstract class SetPasswordState {}

class SetPasswordInitialState extends SetPasswordState {}

class SetPasswordLoadingState extends SetPasswordState {}

/// Password saved and logged in. Every other device was signed out.
class SetPasswordSuccessState extends SetPasswordState {}

class SetPasswordFailureState extends SetPasswordState {
  SetPasswordFailureState(this.result);

  final ApiResult<dynamic> result;

  /// The setup token expired (15 minutes): verify the number again.
  bool get tokenExpired => result.statusCode == 401;
}
