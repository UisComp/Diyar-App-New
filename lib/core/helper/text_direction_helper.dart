import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show Bidi;

/// The direction a piece of user content reads in, decided by its first
/// letter with a direction of its own (the Unicode "first strong" rule, as
/// browsers use for `dir="auto"`): Arabic → right to left, Latin → left to
/// right. Leading digits, punctuation and emoji don't count, so
/// "2026 مشروع" is Arabic and "Villa 9 · فيلا" is English.
///
/// Text with no letters at all (a date, a number) follows [fallback],
/// normally the app's own direction.
abstract class TextDirectionHelper {
  static TextDirection of(
    String text, {
    TextDirection fallback = TextDirection.ltr,
  }) {
    if (Bidi.startsWithRtl(text)) return TextDirection.rtl;
    if (Bidi.startsWithLtr(text)) return TextDirection.ltr;
    return fallback;
  }

  /// [of], falling back to the direction around [context].
  static TextDirection resolve(BuildContext context, String text) =>
      of(text, fallback: Directionality.maybeOf(context) ?? TextDirection.ltr);
}
