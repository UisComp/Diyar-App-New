import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Who is signing in: residents with a phone number, security staff with
/// their work email.
class LoginIdentifier {
  const LoginIdentifier._(this.value, {required this.isEmail});

  /// A number from the phone field, already international.
  const LoginIdentifier.phone(String international)
    : this._(international, isEmail: false);

  /// The email (trimmed, lower case) or the phone number, in international
  /// form when it can be read (`01012345678` → `+201012345678`).
  final String value;
  final bool isEmail;

  bool get isPhone => !isEmail;

  /// Null when [input] is neither a valid email nor a plausible number.
  static LoginIdentifier? tryParse(String input) {
    final text = input.trim();
    if (text.isEmpty) return null;
    if (text.contains('@')) {
      final email = text.toLowerCase();
      return RegExp(AppConstants.emailPattern).hasMatch(email)
          ? LoginIdentifier._(email, isEmail: true)
          : null;
    }
    final phone = normalizePhoneInput(text);
    return phone == null ? null : LoginIdentifier._(phone, isEmail: false);
  }
}

/// A phone number as typed (Arabic digits, spaces, dashes, `00` prefix) in
/// international form. Local numbers are read as Egyptian; other countries
/// need their code (`+971…`). Null if it can't be a phone number.
String? normalizePhoneInput(String input) {
  final buffer = StringBuffer();
  for (final rune in input.trim().runes) {
    final char = String.fromCharCode(rune);
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.write(rune - 0x0660); // Arabic-Indic digits
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.write(rune - 0x06F0); // Eastern Arabic-Indic digits
    } else if (RegExp(r'[0-9+]').hasMatch(char)) {
      buffer.write(char);
    } else if (!RegExp(r'[\s\-().]').hasMatch(char)) {
      return null; // letters or other symbols
    }
  }
  var cleaned = buffer.toString();
  if (cleaned.startsWith('00')) cleaned = '+${cleaned.substring(2)}';
  if (cleaned.indexOf('+') > 0) return null;
  final digits = cleaned.replaceAll('+', '');
  if (digits.length < 8 || digits.length > 15) return null;
  try {
    final parsed = PhoneNumber.parse(cleaned, callerCountry: IsoCode.EG);
    if (parsed.isValid()) return parsed.international;
  } catch (_) {}
  // The backend normalises numbers too; send what we have.
  return cleaned;
}
