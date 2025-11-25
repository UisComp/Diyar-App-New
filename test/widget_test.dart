import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/internet/controller/internet_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';

void main() {
  // تهيئة قبل أي test
  late LanguageController languageController;

  setUpAll(() async {
    // init Hive for testing
    await HiveHelper.init(isTest: true);
    languageController = await LanguageController.create();
  });

  testWidgets('DiyarApp basic smoke test', (WidgetTester tester) async {
    // build app with providers
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<LanguageController>.value(value: languageController),
          BlocProvider(create: (_) => InternetConnectionController()),
        ],
        child: const DiyarApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DiyarApp), findsOneWidget);
  });
}
