import 'package:diyar_app/core/formatter/relative_date.dart';
import 'package:diyar_app/core/helper/text_direction_helper.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Formats every [raw] date in [locale], as the news list would.
Future<List<String?>> _format(
  WidgetTester tester,
  List<String?> raw, {
  required DateTime now,
  Locale locale = const Locale('en'),
}) async {
  late List<String?> out;
  await pumpLocalized(
    tester,
    Builder(
      builder: (context) {
        out = [
          for (final r in raw)
            RelativeDate.format(r, now: now, locale: locale.languageCode),
        ];
        return const SizedBox();
      },
    ),
    locale: locale,
  );
  return out;
}

void main() {
  final now = DateTime(2026, 9, 21, 15, 0);

  group('RelativeDate', () {
    testWidgets('English: from just now to a plain date', (tester) async {
      final out = await _format(tester, [
        '2026-09-21T14:59:40', // seconds ago
        '2026-09-21T14:55:00',
        '2026-09-21T14:59:00',
        '2026-09-21T12:00:00',
        '2026-09-21', // a bare day: no hours to count
        '2026-09-20',
        '2026-09-18',
        '2026-09-14',
        '2026-08-31',
        '2026-08-01', // four weeks and more: the date itself
        '2026-10-05', // scheduled ahead
        null,
        'not a date',
      ], now: now);
      expect(out, [
        'Just now',
        '5 minutes ago',
        '1 minute ago',
        '3 hours ago',
        'Today',
        'Yesterday',
        '3 days ago',
        '1 week ago',
        '3 weeks ago',
        '1 Aug 2026',
        '5 Oct 2026',
        null,
        null,
      ]);
    });

    testWidgets('Arabic: dual, few and many forms', (tester) async {
      final out = await _format(
        tester,
        [
          '2026-09-21T13:00:00',
          '2026-09-21T10:00:00',
          '2026-09-21T14:49:00',
          '2026-09-21',
          '2026-09-20',
          '2026-09-19',
          '2026-09-16',
          '2026-09-14',
          '2026-09-01',
        ],
        now: now,
        locale: const Locale('ar'),
      );
      expect(out, [
        'منذ ساعتين',
        'منذ 5 ساعات',
        'منذ 11 دقيقة',
        'اليوم',
        'أمس',
        'منذ يومين',
        'منذ 5 أيام',
        'منذ أسبوع',
        'منذ أسبوعين',
      ]);
    });

    testWidgets('a UTC timestamp is read in local time', (tester) async {
      final utc = now.toUtc().subtract(const Duration(minutes: 30));
      final out = await _format(tester, [utc.toIso8601String()], now: now);
      expect(out.single, '30 minutes ago');
    });
  });

  group('TextDirectionHelper', () {
    test('the first letter with a direction decides', () {
      const rtl = TextDirection.rtl, ltr = TextDirection.ltr;
      expect(TextDirectionHelper.of('أعمال الكهرباء'), rtl);
      expect(TextDirectionHelper.of('Electrical works'), ltr);
      // Leading digits and punctuation don't count.
      expect(TextDirectionHelper.of('2026 - مشروع لامير'), rtl);
      expect(TextDirectionHelper.of('«Villa 9» فيلا'), ltr);
      expect(TextDirectionHelper.of('فيلا Villa 9'), rtl);
      // No letters at all: the surrounding direction.
      expect(TextDirectionHelper.of('2026-09-21', fallback: rtl), rtl);
      expect(TextDirectionHelper.of('', fallback: ltr), ltr);
    });

    testWidgets('AppText follows its content, not the app', (tester) async {
      await pumpLocalized(
        tester,
        const Column(
          children: [
            AppText('أعمال الكهرباء في التشطيبات'),
            AppText('Electrical works'),
          ],
        ),
      );
      final texts = tester.widgetList<Text>(find.byType(Text)).toList();
      expect(texts[0].textDirection, TextDirection.rtl);
      expect(texts[0].textAlign, TextAlign.right);
      expect(texts[1].textDirection, TextDirection.ltr);
    });
  });
}
