import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/view/finance_screen.dart';
import 'package:diyar_app/feature/home/enums/enum_service.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    const ProfileScreen(),
    BlocProvider(
      create: (context) => FinanceController(),
      child: const FinanceScreen(),
    ),
  ];
  //!App Fonts
  static const String manropeFont = "Manrope";
  static const String newsReaderFont = "NewsReader";
  static const String enableBiometric = "EnableBiometric";
}

String? getScreenNameByServiceType(ServiceType? type) {
  switch (type) {
    case ServiceType.type1:
      return RoutesName.newsScreen;
    case ServiceType.type2:
      return RoutesName.activeWorkScreen; 
    case ServiceType.type3:
      return RoutesName.reportScreen; 
    case ServiceType.type4:
      return RoutesName.newWorkScreen; 
    case ServiceType.type5:
      return RoutesName.financeScreen;
    case ServiceType.type6:
      return RoutesName.addPropertyScreen; 
    case ServiceType.type7:
      return RoutesName.addTenantScreen; 
    case ServiceType.type8:
      return RoutesName.visitorScreen;
    case ServiceType.type9:
      return RoutesName.announcementScreen; 
    case ServiceType.type10:
      return RoutesName.emergencyScreen; 
    case ServiceType.type11:
      return RoutesName.facilityBookingScreen; 
    case ServiceType.type12:
      return RoutesName.serviceProvidersScreen; 
    case ServiceType.type13:
      return RoutesName.committeeScreen; 
    case ServiceType.type14:
      return RoutesName.complainScreen; 
    default:
      return null;
  }
}

