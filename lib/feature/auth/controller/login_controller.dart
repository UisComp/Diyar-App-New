import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/feature/auth/controller/login_state.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/auth/model/login_identifier.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// The one login screen: a phone number (residents) or a work email
/// (security staff), and a password.
///
/// `POST /api/auth/login` takes either one as `login`. It never sends an
/// SMS: codes are only for registration, the first login of accounts
/// created by staff, and "Forgot password?".
class LoginController extends Cubit<LoginState> {
  LoginController() : super(LoginInitialState());

  static LoginController get(BuildContext context) => BlocProvider.of(context);

  /// Residents: a phone number with a country code (Egypt by default).
  final phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
  );

  /// Security staff: their work email.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// The screen shows the email field instead of the phone field.
  bool usesEmail = false;

  void setUseEmail(bool value) {
    if (usesEmail == value) return;
    usesEmail = value;
    emit(LoginModeChangedState());
  }

  /// The phone number or email typed, or null if it isn't valid yet.
  LoginIdentifier? get identifier {
    if (usesEmail) {
      final id = LoginIdentifier.tryParse(emailController.text);
      return id != null && id.isEmail ? id : null;
    }
    final phone = phoneController.value;
    if (phone.nsn.isEmpty || !phone.isValid()) return null;
    return LoginIdentifier.phone(phone.international);
  }

  Future<void> login() async {
    final id = identifier;
    if (state is SignInLoadingState || id == null) return;
    emit(SignInLoadingState());
    final password = passwordController.text;
    final result = await _login(id, password);
    if (isClosed) return;
    if (result.success) {
      await AuthSession.start(
        result.data!,
        message: result.message,
        identifier: id.value,
        password: password,
      );
      if (!isClosed) emit(SignInSuccessState());
    } else {
      emit(SignInFailureState(result, phone: id.isPhone ? id.value : null));
    }
  }

  /// Signs in with the credentials saved at the last login, after the
  /// biometric check passed.
  Future<void> loginWithSavedCredentials() async {
    if (state is SignInLoadingState) return;
    final saved = await HiveHelper.getFromHive(key: AppConstants.myEmail);
    final password = await secureStorage.read(key: AppConstants.myPassword);
    final id = saved is String ? LoginIdentifier.tryParse(saved) : null;
    if (id == null || password == null || password.isEmpty) {
      emit(NoSavedLoginState());
      return;
    }

    emit(SignInLoadingState());
    final result = await _login(id, password);
    if (isClosed) return;

    if (result.success) {
      await AuthSession.start(
        result.data!,
        message: result.message,
        identifier: id.value,
        password: password,
      );
      if (!isClosed) emit(SignInSuccessState());
      return;
    }

    // Saved credentials that can't work again (e.g. a resident's email saved
    // by older versions, or a changed password): forget them rather than
    // failing, and hitting the rate limit, on every attempt.
    final outdated = const {
      ApiErrorCodes.usePhoneLogin,
      ApiErrorCodes.useEmailLogin,
      ApiErrorCodes.wrongCredentials,
      ApiErrorCodes.passwordNotSet,
      ApiErrorCodes.notAllowed,
    }.contains(result.errorCode);
    if (outdated) {
      await clearSavedCredentials();
      await saveBiometricStatus(false);
    }
    if (!isClosed) {
      emit(
        SignInFailureState(
          result,
          phone: id.isPhone ? id.value : null,
          savedLoginOutdated: outdated,
        ),
      );
    }
  }

  Future<ApiResult<LoginData>> _login(
    LoginIdentifier id,
    String password,
  ) async => AuthService.login(
    login: id.value,
    password: password,
    fcmToken: await DeviceHelper.pushToken(),
    platform: DeviceHelper.platform,
  );

  @override
  Future<void> close() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
