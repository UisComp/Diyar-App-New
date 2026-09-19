import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// `+201012345678` → `+20 10 12345678`. Returns [phone] unchanged if it
/// can't be parsed.
String displayPhone(String phone) {
  try {
    final parsed = PhoneNumber.parse(phone);
    return '+${parsed.countryCode} '
        '${parsed.formatNsn(format: NsnFormat.international)}';
  } catch (_) {
    return phone;
  }
}
