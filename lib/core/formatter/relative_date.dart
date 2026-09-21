import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// How long ago something was published, the way news feeds say it:
/// "Just now", "5 minutes ago", "3 hours ago", "Yesterday", "4 days ago",
/// "2 weeks ago", then the date itself ("1 Sep 2026") from four weeks on.
///
/// The API's `news_date` is usually a bare day (`2026-09-01`); such a date
/// has no hours to count, so today reads "Today". A full timestamp
/// (`2026-09-21T10:30:00Z`) gets minutes and hours. A date in the future (a
/// scheduled item) is shown as a date.
abstract class RelativeDate {
  /// Null when [raw] is missing or not a date. [orDate]: false gives null
  /// instead of a date once the item is too old (or ahead) to say "ago",
  /// for screens that already show the date.
  static String? format(
    String? raw, {
    DateTime? now,
    String? locale,
    bool orDate = true,
  }) {
    final date = parse(raw);
    if (date == null) return null;
    final hasTime = raw!.trim().length > 10;
    final current = now ?? DateTime.now();

    final days = _day(current).difference(_day(date)).inDays;
    if (days < 0) return orDate ? _fullDate(date, locale) : null;

    if (days == 0) {
      if (!hasTime) return LocaleKeys.today.tr();
      final elapsed = current.difference(date);
      // A clock slightly ahead of ours still reads as "just now".
      if (elapsed.inMinutes < 1) return LocaleKeys.just_now.tr();
      if (elapsed.inHours < 1) {
        return LocaleKeys.minutes_ago.plural(elapsed.inMinutes);
      }
      return LocaleKeys.hours_ago.plural(elapsed.inHours);
    }
    if (days == 1) return LocaleKeys.yesterday.tr();
    if (days < 7) return LocaleKeys.days_ago.plural(days);
    if (days < 28) return LocaleKeys.weeks_ago.plural(days ~/ 7);
    return orDate ? _fullDate(date, locale) : null;
  }

  /// "21 September 2026", in [locale].
  static String? longDate(String? raw, {String? locale}) {
    final date = parse(raw);
    return date == null ? null : DateFormat('d MMMM yyyy', locale).format(date);
  }

  /// [raw] in local time; null when missing or not a date.
  static DateTime? parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return null;
    return parsed.isUtc ? parsed.toLocal() : parsed;
  }

  /// Midnight of [d]'s day. Built from the date's fields, so a daylight
  /// saving change doesn't shift a day count.
  static DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  static String _fullDate(DateTime date, String? locale) =>
      DateFormat('d MMM yyyy', locale).format(date);
}
