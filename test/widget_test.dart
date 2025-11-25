import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(providers: [], child: const DiyarApp()),
    );

    await tester.pumpAndSettle();
    expect(find.byType(DiyarApp), findsOneWidget);
  });
}
