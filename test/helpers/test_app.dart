import 'package:diyar_app/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pumps [child] inside the app's real localization (generated translations)
/// and ScreenUtil setup, in [locale].
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en'),
  bool wrapInScaffold = true,
  bool settle = true,
}) async {
  await _pump(
    tester,
    locale: locale,
    settle: settle,
    appBuilder: (context) => MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: wrapInScaffold ? Scaffold(body: child) : child,
    ),
  );
}

/// Like [pumpLocalized] but with a [GoRouter], for widgets that navigate.
/// [wrap] puts app-level providers above the app.
Future<void> pumpLocalizedRouter(
  WidgetTester tester,
  GoRouter router, {
  Locale locale = const Locale('en'),
  Widget Function(Widget app)? wrap,
  bool settle = true,
  ThemeData? theme,
}) async {
  await _pump(
    tester,
    locale: locale,
    settle: settle,
    appBuilder: (context) {
      final app = MaterialApp.router(
        routerConfig: router,
        theme: theme,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
      );
      return wrap == null ? app : wrap(app);
    },
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required Locale locale,
  required Widget Function(BuildContext context) appBuilder,
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale('en'),
      startLocale: locale,
      saveLocale: false,
      ignorePluralRules: false,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => Builder(builder: appBuilder),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // For screens with looping animations (loading shimmers).
    await pumpFrames(tester);
  }
}

Future<void> pumpFrames(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
