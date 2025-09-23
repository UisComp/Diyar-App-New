import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/app/diyar_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveHelper.init();
  await DioHelper.init();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationPath,
      fallbackLocale: const Locale(AppConstants.enLanguage),
      startLocale: const Locale(AppConstants.enLanguage),
      saveLocale: true,
      child: const DiyarApp(),
    ),
  );
}
