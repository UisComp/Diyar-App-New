/// A code was texted. Both values are seconds.
class OtpSent {
  const OtpSent({
    this.expiresIn = defaultExpiresIn,
    this.resendIn = defaultResendIn,
  });

  static const defaultExpiresIn = 300;
  static const defaultResendIn = 60;

  final int expiresIn;

  /// When the resend button unlocks.
  final int resendIn;

  factory OtpSent.fromJson(Map<String, dynamic> json) => OtpSent(
    expiresIn: _seconds(json['expires_in']) ?? defaultExpiresIn,
    resendIn: _seconds(json['resend_in']) ?? defaultResendIn,
  );
}

/// A one-use token from a verified code: the password `setup_token`
/// (15 minutes) or the `registration_token` (30 minutes).
class VerifiedToken {
  const VerifiedToken({required this.token, this.expiresIn});

  final String token;
  final int? expiresIn;

  /// Reads [key] (`setup_token` or `registration_token`).
  static VerifiedToken? fromJson(Map<String, dynamic> json, String key) {
    final token = json[key];
    if (token is! String || token.isEmpty) return null;
    return VerifiedToken(token: token, expiresIn: _seconds(json['expires_in']));
  }
}

int? _seconds(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('${value ?? ''}');

/// Why the code screen is open.
enum OtpPurpose {
  /// First login of an account created by staff (no password yet):
  /// code → set password.
  login,

  /// "Forgot password?": same as the first login.
  resetPassword,

  /// Registration: code → the details form.
  register,
}

class OtpArgs {
  const OtpArgs({required this.phone, required this.purpose});

  /// International form, e.g. `+201012345678`.
  final String phone;
  final OtpPurpose purpose;
}

class SetPasswordArgs {
  const SetPasswordArgs({
    required this.phone,
    required this.setupToken,
    this.isReset = false,
  });

  final String phone;

  /// Only good for `POST /api/auth/password`. Never store it as a login.
  final String setupToken;

  /// Came from "Forgot password?" rather than the first login.
  final bool isReset;
}

class RegisterDetailsArgs {
  const RegisterDetailsArgs({
    required this.phone,
    required this.registrationToken,
  });

  final String phone;
  final String registrationToken;
}
