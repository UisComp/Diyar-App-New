/// Stable `errors.code` values returned by the login, registration and
/// phone-number endpoints. See MOBILE-API-CHANGES-AUTH.md §11.
abstract class ApiErrorCodes {
  // Identify / login.
  static const phoneNotRegistered = 'phone_not_registered';
  static const accountPending = 'account_pending';
  static const useEmailLogin = 'use_email_login';
  static const usePhoneLogin = 'use_phone_login';
  static const notAllowed = 'not_allowed';
  static const wrongCredentials = 'wrong_credentials';
  static const passwordNotSet = 'password_not_set';
  static const passwordSetupRequired = 'password_setup_required';

  // Any SMS code check.
  static const invalid = 'invalid';
  static const burned = 'burned';
  static const expired = 'expired';

  // Any SMS code request.
  static const resendWait = 'resend_wait';
  static const tooMany = 'too_many';
  static const deliveryFailed = 'delivery_failed';

  // Registration.
  static const registrationPaused = 'registration_paused';
  static const phoneAlreadyRegistered = 'phone_already_registered';
  static const registrationPending = 'registration_pending';
  static const registrationTokenInvalid = 'registration_token_invalid';

  // Phone change requests.
  static const numberTaken = 'number_taken';
  static const numberPending = 'number_pending';
  static const tooManyPending = 'too_many_pending';
  static const targetPending = 'target_pending';
  static const lastNumber = 'last_number';
  static const notYourNumber = 'not_your_number';
  static const notPending = 'not_pending';

  /// The code can't be used any more: the user must request a new one.
  static bool isDeadCode(String? code) => code == burned || code == expired;
}
