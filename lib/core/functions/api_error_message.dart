import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// Translation key for a known `errors.code`, or null.
String? apiErrorKey(String? code) => switch (code) {
  ApiErrorCodes.phoneNotRegistered => LocaleKeys.err_phone_not_registered,
  ApiErrorCodes.accountPending => LocaleKeys.err_account_pending,
  ApiErrorCodes.useEmailLogin => LocaleKeys.err_use_email_login,
  ApiErrorCodes.usePhoneLogin => LocaleKeys.err_use_phone_login,
  ApiErrorCodes.notAllowed => LocaleKeys.err_not_allowed,
  ApiErrorCodes.wrongCredentials => LocaleKeys.err_wrong_credentials,
  ApiErrorCodes.passwordNotSet => LocaleKeys.err_password_not_set,
  ApiErrorCodes.passwordSetupRequired => LocaleKeys.err_password_setup_required,
  ApiErrorCodes.invalid => LocaleKeys.err_invalid_code,
  ApiErrorCodes.burned => LocaleKeys.err_code_burned,
  ApiErrorCodes.expired => LocaleKeys.err_code_expired,
  ApiErrorCodes.resendWait => LocaleKeys.err_resend_wait,
  ApiErrorCodes.tooMany => LocaleKeys.err_too_many_codes,
  ApiErrorCodes.deliveryFailed => LocaleKeys.err_delivery_failed,
  ApiErrorCodes.registrationPaused => LocaleKeys.err_registration_paused,
  ApiErrorCodes.phoneAlreadyRegistered =>
    LocaleKeys.err_phone_already_registered,
  ApiErrorCodes.registrationPending => LocaleKeys.err_registration_pending,
  ApiErrorCodes.registrationTokenInvalid =>
    LocaleKeys.err_registration_token_invalid,
  ApiErrorCodes.numberTaken => LocaleKeys.err_number_taken,
  ApiErrorCodes.numberPending => LocaleKeys.err_number_pending,
  ApiErrorCodes.tooManyPending => LocaleKeys.err_too_many_pending,
  ApiErrorCodes.targetPending => LocaleKeys.err_target_pending,
  ApiErrorCodes.lastNumber => LocaleKeys.err_last_number,
  ApiErrorCodes.notYourNumber => LocaleKeys.err_not_your_number,
  ApiErrorCodes.notPending => LocaleKeys.err_not_pending,
  _ => null,
};

/// What to show the user for a failed [result], in the app's language.
String apiErrorMessage(ApiResult<dynamic> result, {String? fallback}) {
  if (result.isNetworkError) {
    return LocaleKeys.please_check_your_internet_connection.tr();
  }
  final code = result.errorCode;
  final serverMessage = (result.message?.trim().isNotEmpty ?? false)
      ? result.message!.trim()
      : null;

  // The server's message says how many tries are left.
  if (code == ApiErrorCodes.invalid && serverMessage != null) {
    return serverMessage;
  }
  if (code == ApiErrorCodes.resendWait) {
    final wait = result.retryAfter;
    if (wait != null && wait > 0) {
      return LocaleKeys.err_resend_wait.tr(args: ['$wait']);
    }
    return serverMessage ?? LocaleKeys.err_too_many_codes.tr();
  }
  final key = apiErrorKey(code);
  if (key != null) return key.tr();

  if (result.firstFieldError != null) return result.firstFieldError!;
  if (result.statusCode == 429) return LocaleKeys.err_too_many_attempts.tr();
  return serverMessage ?? fallback ?? LocaleKeys.something_went_wrong.tr();
}
