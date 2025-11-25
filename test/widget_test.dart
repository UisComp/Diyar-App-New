import 'package:diyar_app/feature/internet/controller/internet_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';

void main() {
  testWidgets('DiyarApp basic smoke test', (WidgetTester tester) async {
    final languageController = await LanguageController.create();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<LanguageController>.value(value: languageController),
          BlocProvider(create: (_) => InternetConnectionController()),
          // أضف أي Bloc آخر أساسي يحتاجه DiyarApp
        ],
        child: const DiyarApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DiyarApp), findsOneWidget);
  });
}
