import 'package:diyar_app/bloc_observer.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await HiveHelper.init();
  await DioHelper.init();
  Bloc.observer = AppBlocObserver();
  userModel = await HiveHelper.getUserModel(AppConstants.userModelKey);
  enableBiometric = await HiveHelper.getFromHive(
    key: AppConstants.enableBiometric,
  );
  final languageController = await LanguageController.create();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationPath,
      fallbackLocale: const Locale(AppConstants.enLanguage),
      startLocale: languageController.getLocaleFromMode(),
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageController>.value(value: languageController),
          BlocProvider(create: (_) => AppThemeController()),
          BlocProvider(create: (_) => ProfileController()),
          BlocProvider(create: (_) => SettingsController()),
        ],
        child: const DiyarApp(),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}
