// ignore_for_file: use_build_context_synchronously
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/enums/language_mode.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LanguageController extends Cubit<LanguageState> {
  LanguagesMode currentLanguageMode;

  LanguageController._internal(this.currentLanguageMode)
    : super(LanguageInitailState());
  static Future<LanguageController> create() async {
    final savedLang = await HiveHelper.getFromHive(
      key: AppConstants.myCurrentLanguagekey,
    );
    final mode = savedLang == "ar"
        ? LanguagesMode.arabic
        : LanguagesMode.english;
    return LanguageController._internal(mode);
  }

  static LanguageController get(BuildContext context) =>
      BlocProvider.of<LanguageController>(context);

  Locale getLocaleFromMode() {
    return currentLanguageMode == LanguagesMode.arabic
        ? const Locale(AppConstants.arLanguage)
        : const Locale(AppConstants.enLanguage);
  }

  Future<void> changeCurrentLanguageMode(
    BuildContext context,
    LanguagesMode lang,
  ) async {
    currentLanguageMode = lang;
    final newLocale = lang == LanguagesMode.arabic
        ? const Locale(AppConstants.arLanguage)
        : const Locale(AppConstants.enLanguage);
    await HiveHelper.addToHive(
      key: AppConstants.myCurrentLanguagekey,
      value: lang == LanguagesMode.arabic ? "ar" : "en",
    );
    await context.setLocale(newLocale);
    emit(ChangeCurrentLanguageState());
  }
}
