import 'dart:developer';

import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/model/change_password_request_model.dart';
import 'package:diyar_app/feature/settings/model/change_password_response_model.dart';
import 'package:diyar_app/feature/settings/service/settings_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsController extends Cubit<SettingsState> {
  SettingsController() : super(SettingsInitialState());
  static SettingsController get(BuildContext context) =>
      BlocProvider.of(context);
  ChangePasswordResponseModel changePasswordResponseModel =
      ChangePasswordResponseModel();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirmation = TextEditingController();
  Future<void> changePassword() async {
    emit(ChangePasswordLoadingState());
    await SettingsService.changePassword(
          changePasswordRequestModel: ChangePasswordRequestModel(
            currentPassword: currentPassword.text,
            newPassword: newPassword.text,
            newPasswordConfirmation: newPasswordConfirmation.text,
          ),
        )
        .then((value) {
          changePasswordResponseModel = value;
          if (value.success == true) {
            emit(ChangePasswordSuccessfullyState());
          } else {
            emit(ChangePasswordFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Change Password is $error');
          emit(ChangePasswordFailureState(error: error.toString()));
        });
  }
}
