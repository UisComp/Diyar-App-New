import 'package:flutter/services.dart';

/// Unit codes are upper case (`b1-g-01` → `B1-G-01`), matching what the
/// server stores.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
