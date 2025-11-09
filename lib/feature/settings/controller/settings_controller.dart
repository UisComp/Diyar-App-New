import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/model/change_password_request_model.dart';
import 'package:diyar_app/feature/settings/model/change_password_response_model.dart';
import 'package:diyar_app/feature/settings/model/config_data_model.dart';
import 'package:diyar_app/feature/settings/service/settings_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends Cubit<SettingsState> {
  SettingsController() : super(SettingsInitialState());
  static SettingsController get(BuildContext context) =>
      BlocProvider.of(context);
  ChangePasswordResponseModel changePasswordResponseModel =
      ChangePasswordResponseModel();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirmation = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
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
          AppLogger.error('Error Happen While Change Password is $error');
          emit(ChangePasswordFailureState(error: error.toString()));
        });
  }

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> initialize() async {
    try {
      emit(BiometricLoading());
      isEnabled = await loadBiometricStatus();
      AppLogger.success(
        'BiometricCubit: Initialized with isEnabled = $isEnabled',
      );
      if (isEnabled == true) {
        emit(BiometricEnabled());
      } else {
        emit(BiometricDisabled());
      }
    } catch (e) {
      AppLogger.error('BiometricCubit: Error initializing biometric: $e');
      emit(BiometricError(e.toString()));
    }
  }

  Future<void> enableBiometrics(BuildContext context) async {
    try {
      emit(BiometricLoading());

      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        emit(BiometricNotSupported());
        return;
      }

      final available = await _localAuth.getAvailableBiometrics();

      bool hasBiometric =
          available.contains(BiometricType.face) ||
          available.contains(BiometricType.fingerprint);

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometrics',
        biometricOnly: hasBiometric,
        persistAcrossBackgrounding: true,
      );

      if (isAuthenticated) {
        await saveBiometricStatus(true);
        emit(BiometricEnabled());
      } else {
        await saveBiometricStatus(false);
        emit(BiometricDisabled());
      }
    } on LocalAuthException catch (e) {
      AppLogger.error('LocalAuthException enabling biometrics: $e');
      if (e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        showLockRequiredDialog(context);
        emit(BiometricLockNotSet());
        return;
      }

      emit(BiometricError('Failed: ${e.code}'));
    } catch (e) {
      AppLogger.error('Error enabling biometrics: $e');
      emit(BiometricError('Failed: $e'));
    }
  }

  Future<void> disableBiometrics() async {
    try {
      emit(BiometricLoading());
      await _saveBiometricStatus(false);
      emit(BiometricDisabled());
      AppLogger.success('Biometrics disabled successfully');
    } catch (e) {
      AppLogger.error('Error disabling biometrics: $e');
      emit(BiometricError('Failed to disable biometrics: $e'));
    }
  }

  bool isEnabled = false;
  Future<bool> authenticateWithBiometrics() async {
    try {
      isEnabled = await loadBiometricStatus();
      if (!isEnabled) {
        AppLogger.warning('Biometrics not enabled');
        return false;
      }

      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canCheckBiometrics && !isDeviceSupported) {
        AppLogger.warning('Device does not support biometrics');
        return false;
      }

      final available = await _localAuth.getAvailableBiometrics();

      bool hasBiometric =
          available.contains(BiometricType.face) ||
          available.contains(BiometricType.fingerprint);
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        biometricOnly: hasBiometric,
        persistAcrossBackgrounding: true,
      );
      AppLogger.info(
        'Biometric authentication ${isAuthenticated ? 'successful' : 'failed'}',
      );
      return isAuthenticated;
    } catch (e) {
      AppLogger.error('Biometric authentication error: $e');
      return false;
    }
  }

  Future<bool> loadBiometricStatus() async {
    try {
      final isEnabled = await HiveHelper.getFromHive(
        key: AppConstants.enableBiometric,
      );
      if (isEnabled == null) {
        AppLogger.warning('isEnabled in loadBiometricStatus: $isEnabled');

        return false;
      }
      AppLogger.success('Biometric: Loaded biometric status: $isEnabled');
      return isEnabled;
    } catch (e) {
      AppLogger.error('Biometric: Error loading biometric status: $e');
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
      AppLogger.success('saveBiometricStatus when adding to hive: $isEnabled');
    } catch (e) {
      AppLogger.error('Biometric: Error saving biometric status: $e');
      throw Exception(e);
    }
  }

  GeneralResponseModel deleteAccountResponseModel = GeneralResponseModel();
  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    await SettingsService.deleteAccount()
        .then((value) async {
          deleteAccountResponseModel = value;
          AppLogger.info(
            'deleteAccountResponseModel $deleteAccountResponseModel',
          );
          if (value.success == true) {
            await HiveHelper.clearAllData();
            emit(DeleteAccountSuccessfullyState());
          } else {
            emit(DeleteAccountFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Delete Account is $error');
          emit(DeleteAccountFailureState(error: error.toString()));
        });
  }

  ConfigResponseModel configResponseModel = ConfigResponseModel();

  Future<void> getConfigData() async {
    emit(GetConfigDataLoadingState());
    await SettingsService.getConfigData()
        .then((value) async {
          configResponseModel = value;
          AppLogger.info('configResponseModel $configResponseModel');
          if (value.success == true) {
            emit(GetConfigDataSuccessfullyState());
          } else {
            emit(GetConfigDataFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While get configResponseModel is $error',
          );
          emit(GetConfigDataFailureState(error: error.toString()));
        });
  }

  Future<void> sendEmail() async {
    emit(SendEmailLoadingState());
    final subject = Uri.encodeComponent('Contact with Diyar');
    final body = Uri.encodeComponent('''
Dear Diyar,
${messageController.text}
Sender Name: ${nameController.text}
''');

    final uri = Uri.parse(
      'mailto:${configResponseModel.data?.contactEmail}?subject=$subject&body=$body',
    );
    AppLogger.log("uri: $uri");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      emit(SendEmailSuccessfullyState());
    } else {
      emit(SendEmailFailureState(error: 'Could not launch email app'));
      throw 'Could not launch email app';
    }
  }

  void clearFields() {
    nameController.clear();
    messageController.clear();
    emailController.clear();
    emit(state);
  }

  bool enableNotification = false;

  void toggleNotification() {
    enableNotification = !enableNotification;
    if (enableNotification == true) {
      emit(EnableNotificationState());
    } else {
      emit(DisableNotificationState());
    }
  }

  bool emailNotification = false;

  void toggleEmailNotification() {
    emailNotification = !emailNotification;
    if (emailNotification == true) {
      emit(EnableEmailNotificationState());
    } else {
      emit(DisableEmailNotificationState());
    }
  }
}
