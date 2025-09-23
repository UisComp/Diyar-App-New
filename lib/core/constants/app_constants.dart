import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Diyar";
  static const String arLanguage = "ar";
  static const String enLanguage = "en";
  static const String translationPath = "assets/translations";
  static List<Locale> supportedLocales = [
    const Locale(enLanguage),
    const Locale(arLanguage),
  ];
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
 static final List<Widget> screens = const [
    SettingsScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  //!App Fonts
  static const String manropeFont = "Manrope";
  static const String newsReaderFont = "NewsReader";
}
