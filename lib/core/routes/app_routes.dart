import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/view/login_screen.dart';
import 'package:diyar_app/feature/auth/view/register_screen.dart';
import 'package:diyar_app/feature/home/layout/home_layout.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/on_boarding/view/on_boarding_screen.dart';
import 'package:diyar_app/feature/settings/view/app_preferences.dart';
import 'package:diyar_app/feature/settings/view/change_password.dart';
import 'package:diyar_app/feature/settings/view/contact_us_screen.dart';
import 'package:diyar_app/feature/settings/view/personal_information.dart';
import 'package:diyar_app/feature/settings/view/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesName.homeLayout,
  routes: <RouteBase>[
    GoRoute(
      name: RoutesName.onBoarding,
      path: RoutesName.onBoarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnBoardingScreen();
      },
    ),
    GoRoute(
      name: RoutesName.homeLayout,
      path: RoutesName.homeLayout,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeLayout();
      },
    ),
    GoRoute(
      name: RoutesName.login,
      path: RoutesName.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      name: RoutesName.register,
      path: RoutesName.register,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      name: RoutesName.home,
      path: RoutesName.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      name: RoutesName.personalInformation,
      path: RoutesName.personalInformation,
      builder: (BuildContext context, GoRouterState state) {
        return const PersonalInformation();
      },
    ),
    GoRoute(
      name: RoutesName.privacyPolicy,
      path: RoutesName.privacyPolicy,
      builder: (BuildContext context, GoRouterState state) {
        return const PrivacyPolicy();
      },
    ),
    GoRoute(
      name: RoutesName.changePasswordScreen,
      path: RoutesName.changePasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      name: RoutesName.appPreferencesScreen,
      path: RoutesName.appPreferencesScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AppPreferencesScreen();
      },
    ),
    // GoRoute(
    //   name: RoutesName.helpSupportScreen,
    //   path: RoutesName.helpSupportScreen,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const HelpSupportScreen();
    //   },
    // ),
    GoRoute(
      name: RoutesName.contactUsScreen,
      path: RoutesName.contactUsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ContactUsScreen();
      },
    ),
  ],
);
