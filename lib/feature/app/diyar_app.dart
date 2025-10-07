import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/routes/app_routes.dart';
import 'package:diyar_app/core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiyarApp extends StatelessWidget {
  const DiyarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<LanguageController, LanguageState>(
              listener: (context, state) async {
                final languageController = LanguageController.get(context);
                final locale = languageController.getLocaleFromMode();
                await context.setLocale(locale);
              },
            ),
          ],
          child: BlocBuilder<AppThemeController, AppThemeState>(
            builder: (context, themeState) {
              final themeController = AppThemeController.get(context);
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                themeMode: themeController.currentThemeMode == AppThemeMode.dark
                    ? ThemeMode.dark
                    : themeController.currentThemeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.system,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
              );
            },
          ),
        );
      },
    );
  }
}
