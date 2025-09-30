import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/view/forget_password_screen.dart';
import 'package:diyar_app/feature/auth/view/login_screen.dart';
import 'package:diyar_app/feature/auth/view/otp_screen.dart';
import 'package:diyar_app/feature/auth/view/register_screen.dart';
import 'package:diyar_app/feature/auth/view/reset_password_screen.dart';
import 'package:diyar_app/feature/finance/view/finance_screen.dart';
import 'package:diyar_app/feature/home/layout/home_layout.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/news/view/news_details_screen.dart';
import 'package:diyar_app/feature/news/view/news_screen.dart';
import 'package:diyar_app/feature/on_boarding/view/on_boarding_screen.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/project/view/project_details.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/view/app_preferences.dart';
import 'package:diyar_app/feature/settings/view/change_password.dart';
import 'package:diyar_app/feature/settings/view/contact_us_screen.dart';
import 'package:diyar_app/feature/profile/view/personal_information.dart';
import 'package:diyar_app/feature/settings/view/privacy_policy.dart';
import 'package:diyar_app/feature/unit_event/view/unit_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesName.onBoarding,
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
    //!Auth
    GoRoute(
      name: RoutesName.login,
      path: RoutesName.login,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => AuthController(),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      name: RoutesName.register,
      path: RoutesName.register,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => AuthController(),
          child: const RegisterScreen(),
        );
      },
    ),
    GoRoute(
      name: RoutesName.forgetPasswordScreen,
      path: RoutesName.forgetPasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => AuthController(),
          child: const ForgetPasswordScreen(),
        );
      },
    ),
    GoRoute(
      name: RoutesName.resetPasswordScreen,
      path: RoutesName.resetPasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => AuthController(),
          child: const ResetPasswordScreen(),
        );
      },
    ),
     GoRoute(
      name: RoutesName.otpScreen,
      path: RoutesName.otpScreen,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => AuthController(),
          child: const OtpScreen(),
        );
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
        return BlocProvider(
          create: (context) => ProfileController(),
          child: const PersonalInformation(),
        );
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
        return BlocProvider(
          create: (context) => SettingsController(),
          child: const ChangePasswordScreen(),
        );
      },
    ),
    GoRoute(
      name: RoutesName.appPreferencesScreen,
      path: RoutesName.appPreferencesScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AppPreferencesScreen();
      },
    ),
    GoRoute(
      name: RoutesName.financeScreen,
      path: RoutesName.financeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const FinanceScreen();
      },
    ),
    GoRoute(
      name: RoutesName.contactUsScreen,
      path: RoutesName.contactUsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ContactUsScreen();
      },
    ),
    GoRoute(
      name: RoutesName.projectDetails,
      path: RoutesName.projectDetails,
      builder: (BuildContext context, GoRouterState state) {
        return const ProjectDetails();
      },
    ),
    GoRoute(
      name: RoutesName.unitEvents,
      path: RoutesName.unitEvents,
      builder: (BuildContext context, GoRouterState state) {
        return const UnitEvent();
      },
    ),
    GoRoute(
      name: RoutesName.newsScreen,
      path: RoutesName.newsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const NewsScreen();
      },
    ),
    GoRoute(
      name: RoutesName.newsDetailsScreen,
      path: RoutesName.newsDetailsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const NewsDetailsScreen();
      },
    ),
  ],
);
