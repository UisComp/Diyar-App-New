import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';
import 'package:diyar_app/feature/news/view/news_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Shows [news] as if `GET /news/{id}` had just returned it.
class _LoadedNewsController extends NewsController {
  _LoadedNewsController(NewsDataDetails news) {
    newsDetailsResponseModel = NewsDetailsResponseModel(
      success: true,
      data: news,
    );
    emit(GetNewsDetailsSuccessfullyState());
  }
}

Future<void> _pump(WidgetTester tester, NewsDataDetails news) =>
    pumpLocalized(
      tester,
      BlocProvider<NewsController>(
        create: (_) => _LoadedNewsController(news),
        child: const NewsDetailsScreen(),
      ),
      wrapInScaffold: false,
    );

Text _textOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text));

void main() {
  const arabicTitle = 'أعمال الكهرباء في التشطيبات';
  const arabicParagraph = 'تُعد أعمال الكهرباء من أهم مراحل التشطيبات.';
  const englishParagraph = 'Electrical works come first.';

  testWidgets('an Arabic article in the English app reads right to left', (
    tester,
  ) async {
    await _pump(
      tester,
      const NewsDataDetails(
        id: 1,
        title: arabicTitle,
        content: '$arabicParagraph\n\n$englishParagraph',
        newsDate: '2026-09-01',
        project: Project(id: 1, name: 'La Mer'),
        unit: Unit(id: 9, name: 'V-9'),
      ),
    );

    // Each paragraph on its own side, whatever the app's language is.
    expect(_textOf(tester, arabicTitle).textDirection, TextDirection.rtl);
    expect(_textOf(tester, arabicParagraph).textDirection, TextDirection.rtl);
    expect(_textOf(tester, englishParagraph).textDirection, TextDirection.ltr);

    // Full width, so right-aligned text really sits against the right edge.
    final screen = tester.getRect(find.byType(NewsDetailsScreen));
    final title = tester.getRect(find.text(arabicTitle));
    expect(title.width, closeTo(screen.width - 32 * screen.width / 390, 1));

    expect(find.text('La Mer'), findsOneWidget);
    expect(find.text('V-9'), findsOneWidget);
    expect(find.textContaining('1 September 2026'), findsOneWidget);
    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('no pictures, no carousel', (tester) async {
    await _pump(
      tester,
      const NewsDataDetails(id: 2, title: 'Handover', content: 'Soon.'),
    );
    expect(find.byType(PageView), findsNothing);
    expect(_textOf(tester, 'Handover').textDirection, TextDirection.ltr);
  });
}
