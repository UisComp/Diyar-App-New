import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/feature/auth/controller/set_password_state.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Last step of the first login and of "Forgot password?".
class SetPasswordController extends Cubit<SetPasswordState> {
  SetPasswordController({required this.args})
    : super(SetPasswordInitialState());

  static SetPasswordController get(BuildContext context) =>
      BlocProvider.of(context);

  static const minLength = 8;

  final SetPasswordArgs args;
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();

  Future<void> submit() async {
    if (state is SetPasswordLoadingState) return;
    emit(SetPasswordLoadingState());
    final password = passwordController.text;
    final result = await AuthService.setPassword(
      setupToken: args.setupToken,
      password: password,
      passwordConfirmation: confirmationController.text,
      fcmToken: await DeviceHelper.pushToken(),
      platform: DeviceHelper.platform,
    );
    if (isClosed) return;
    if (!result.success) {
      emit(SetPasswordFailureState(result));
      return;
    }
    await AuthSession.start(
      result.data!,
      message: result.message,
      identifier: args.phone,
      password: password,
    );
    if (!isClosed) emit(SetPasswordSuccessState());
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmationController.dispose();
    return super.close();
  }
}
