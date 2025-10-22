import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/home/enums/enum_service.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Diyar";
  static const String arLanguage = "ar";
  static const String enLanguage = "en";
  static const String userModelKey = "userModelKey";
  static const String emailKey = "emailKey";
  static const String refreshTokenKey = "refreshTokenKey";
  static const String myCurrentLanguagekey = "myCurrentLanguage";
  static const String translationPath = "assets/translations";
  static const String hiveDarkMode = "hiveDarkMode";
  static const String myEmail = "myEmail";
  static const String myPassword = "myPassword";
  static const String fcmToken = "fcmToken";
  static List<Locale> supportedLocales = [
    const Locale(enLanguage),
    const Locale(arLanguage),
  ];
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static final List<Widget> screens = [
    const SettingsScreen(),
    const HomeScreen(),
    ProfileScreen(),
  ];
  //!App Fonts
  static const String manropeFont = "Manrope";
  static const String newsReaderFont = "NewsReader";
  static const String enableBiometric = "EnableBiometric";
}

// String? getScreenNameByType(int? type) {
//   switch (type) {
//     case 1:
//       return RoutesName.newsScreen;
//     case 5:
//       return RoutesName.financeScreen;
//     default:
//       return null;
//   }
// }

String? getScreenNameByServiceType(ServiceType? type) {
  switch (type) {
    case ServiceType.type1:
      return RoutesName.newsScreen;
    case ServiceType.type5:
      return RoutesName.financeScreen;
    default:
      return null;
  }
}
