import 'dart:developer';

import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/model/change_password_request_model.dart';
import 'package:diyar_app/feature/settings/model/change_password_response_model.dart';
import 'package:diyar_app/feature/settings/service/settings_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

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

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> initialize() async {
    try {
      emit(BiometricLoading());
      isEnabled = await loadBiometricStatus();
      log('BiometricCubit: Initialized with isEnabled = $isEnabled');
      if (isEnabled == true) {
        emit(BiometricEnabled());
      } else {
        emit(BiometricDisabled());
      }
    } catch (e) {
      log('BiometricCubit: Error initializing biometric: $e');
      emit(BiometricError(e.toString()));
    }
  }

  Future<void> enableBiometrics(BuildContext context) async {
    try {
      emit(BiometricLoading());
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        emit(BiometricNotSupported());
        return;
      }
      final hasDeviceLock = await _localAuth.isDeviceSupported();
      if (!hasDeviceLock) {
        showLockRequiredDialog(context);
        emit(BiometricLockNotSet());
        return;
      }
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometrics',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (isAuthenticated) {
        await saveBiometricStatus(true);
        emit(BiometricEnabled());
      } else {
        await saveBiometricStatus(false);
        emit(BiometricDisabled());
      }
    } catch (e) {
      log('Error enabling biometrics: $e');
      emit(BiometricError('Failed to enable biometrics: $e'));
    }
  }

  Future<void> disableBiometrics() async {
    try {
      emit(BiometricLoading());
      await _saveBiometricStatus(false);
      emit(BiometricDisabled());
      log('Biometrics disabled successfully');
    } catch (e) {
      log('Error disabling biometrics: $e');
      emit(BiometricError('Failed to disable biometrics: $e'));
    }
  }

  bool isEnabled = false;
  Future<bool> authenticateWithBiometrics() async {
    try {
      isEnabled = await loadBiometricStatus();
      if (!isEnabled) {
        log(' Biometrics not enabled');
        return false;
      }

      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canCheckBiometrics && !isDeviceSupported) {
        log(' Device does not support biometrics');
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      log(
        'Biometric authentication ${isAuthenticated ? 'successful' : 'failed'}',
      );
      return isAuthenticated;
    } catch (e) {
      log(' Biometric authentication error: $e');
      return false;
    }
  }

  Future<bool> loadBiometricStatus() async {
    try {
      final isEnabled = await HiveHelper.getFromHive(
        key: AppConstants.enableBiometric,
      );
      if (isEnabled == null) {
        log('isEnabled in loadBiometricStatus: $isEnabled');

        return false;
      }
      log('Biometric: Loaded biometric status: $isEnabled');
      return isEnabled;
    } catch (e) {
      log('Biometric: Error loading biometric status: $e');
      return false;
    }
  }

  Future<void> _saveBiometricStatus(bool isEnabled) async {
    this.isEnabled = isEnabled;
    try {
      await HiveHelper.addToHive(
        key: AppConstants.enableBiometric,
        value: isEnabled,
      );
      log('_saveBiometricStatus when adding to hive: $isEnabled');
    } catch (e) {
      log('Biometric: Error saving biometric status: $e');
      throw Exception(e);
    }
  }

  GeneralResponseModel deleteAccountResponseModel = GeneralResponseModel();
  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    await SettingsService.deleteAccount()
        .then((value) async {
          deleteAccountResponseModel = value;
          log('deleteAccountResponseModel $deleteAccountResponseModel');
          if (value.success == true) {
            await HiveHelper.clearAllData();
            emit(DeleteAccountSuccessfullyState());
          } else {
            emit(DeleteAccountFailureState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Delete Account is $error');
          emit(DeleteAccountFailureState(error: error.toString()));
        });
  }
}
