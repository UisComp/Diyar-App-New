import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/view/forget_password_screen.dart';
import 'package:diyar_app/feature/auth/view/login_screen.dart';
import 'package:diyar_app/feature/auth/view/otp_screen.dart';
import 'package:diyar_app/feature/auth/view/register_screen.dart';
import 'package:diyar_app/feature/auth/view/reset_password_screen.dart';
import 'package:diyar_app/feature/finance/view/finance_screen.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/layout/home_layout.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/view/news_details_screen.dart';
import 'package:diyar_app/feature/news/view/news_screen.dart';
import 'package:diyar_app/feature/on_boarding/view/on_boarding_screen.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/view/project_details.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/view/app_preferences.dart';
import 'package:diyar_app/feature/settings/view/change_password.dart';
import 'package:diyar_app/feature/settings/view/contact_us_screen.dart';
import 'package:diyar_app/feature/profile/view/personal_information.dart';
import 'package:diyar_app/feature/settings/view/privacy_policy.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_controller.dart';
import 'package:diyar_app/feature/unit_event/view/unit_event.dart';
import 'package:diyar_app/feature/view_all_services/view/view_all_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> buildAnimatedPage<T>({
  required Widget child,
  required Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )
  transition,
}) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: transition,
  );
}

SlideTransition slideFromRight(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
    child: child,
  );
}

SlideTransition slideFromLeft(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
    child: child,
  );
}

SlideTransition slideFromBottom(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
    child: child,
  );
}

FadeTransition fadeIn(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

ScaleTransition scaleIn(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return ScaleTransition(
    scale: Tween(
      begin: 0.9,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(animation),
    child: child,
  );
}

AnimatedBuilder rotateY(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final rotate = (1 - animation.value) * 1.2;
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotate),
        alignment: Alignment.center,
        child: child,
      );
    },
    child: child,
  );
}

FadeTransition zoomFadeIn(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
      child: child,
    ),
  );
}

SlideTransition elasticSlideUp(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.elasticOut)).animate(animation),
    child: child,
  );
}

final GoRouter router = GoRouter(
  initialLocation: userModel?.data?.accessToken != null
      ? RoutesName.homeLayout
      : RoutesName.onBoarding,
  routes: <RouteBase>[
    GoRoute(
      name: RoutesName.onBoarding,
      path: RoutesName.onBoarding,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: const OnBoardingScreen(),
        transition: zoomFadeIn,
      ),
    ),
    GoRoute(
      name: RoutesName.homeLayout,
      path: RoutesName.homeLayout,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => HomeController(),
          child: const HomeLayout(),
        ),
        transition: slideFromLeft,
      ),
    ),
    GoRoute(
      name: RoutesName.home,
      path: RoutesName.home,
      pageBuilder: (context, state) =>
          buildAnimatedPage(child: const HomeScreen(), transition: fadeIn),
    ),
    GoRoute(
      name: RoutesName.login,
      path: RoutesName.login,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => AuthController(),
          child: LoginScreen(),
        ),
        transition: slideFromRight,
      ),
    ),
    GoRoute(
      name: RoutesName.register,
      path: RoutesName.register,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => AuthController(),
          child: RegisterScreen(),
        ),
        transition: slideFromRight,
      ),
    ),
    GoRoute(
      name: RoutesName.forgetPasswordScreen,
      path: RoutesName.forgetPasswordScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => AuthController(),
          child: const ForgetPasswordScreen(),
        ),
        transition: slideFromBottom,
      ),
    ),
    GoRoute(
      name: RoutesName.resetPasswordScreen,
      path: RoutesName.resetPasswordScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => AuthController(),
          child: const ResetPasswordScreen(),
        ),
        transition: slideFromBottom,
      ),
    ),
    GoRoute(
      name: RoutesName.otpScreen,
      path: RoutesName.otpScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => AuthController(),
          child: const OtpScreen(),
        ),
        transition: scaleIn,
      ),
    ),
    GoRoute(
      name: RoutesName.personalInformation,
      path: RoutesName.personalInformation,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: const PersonalInformation(),
        transition: slideFromRight,
      ),
    ),
    GoRoute(
      name: RoutesName.profileScreen,
      path: RoutesName.profileScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: const ProfileScreen(),
        transition: slideFromRight,
      ),
    ),
    GoRoute(
      name: RoutesName.appPreferencesScreen,
      path: RoutesName.appPreferencesScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: const AppPreferencesScreen(),
        transition: fadeIn,
      ),
    ),
    GoRoute(
      name: RoutesName.changePasswordScreen,
      path: RoutesName.changePasswordScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => SettingsController(),
          child: const ChangePasswordScreen(),
        ),
        transition: slideFromRight,
      ),
    ),
    GoRoute(
      name: RoutesName.contactUsScreen,
      path: RoutesName.contactUsScreen,
      pageBuilder: (context, state) =>
          buildAnimatedPage(child: const ContactUsScreen(), transition: fadeIn),
    ),
    GoRoute(
      name: RoutesName.privacyPolicy,
      path: RoutesName.privacyPolicy,
      pageBuilder: (context, state) =>
          buildAnimatedPage(child: const PrivacyPolicy(), transition: fadeIn),
    ),
    GoRoute(
      name: RoutesName.projectDetails,
      path: RoutesName.projectDetails,
      pageBuilder: (context, state) {
        final projectId = state.extra as String?;
        return buildAnimatedPage(
          child: BlocProvider(
            create: (_) =>
                ProjectController()..getProjectDetails(id: projectId ?? ''),
            child: const ProjectDetails(),
          ),
          transition: scaleIn,
        );
      },
    ),
    GoRoute(
      name: RoutesName.unitEvents,
      path: RoutesName.unitEvents,
      pageBuilder: (context, state) {
        final projectId = state.extra as int;
        return buildAnimatedPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UnitEventController()),
              BlocProvider(create: (_) => ProjectController()),
            ],
            child: UnitEvent(projectId: projectId),
          ),
          transition: elasticSlideUp,
        );
      },
    ),
    GoRoute(
      name: RoutesName.newsScreen,
      path: RoutesName.newsScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => NewsController()..getAllNews(),
          child: const NewsScreen(),
        ),
        transition: fadeIn,
      ),
    ),
    GoRoute(
      name: RoutesName.newsDetailsScreen,
      path: RoutesName.newsDetailsScreen,
      pageBuilder: (context, state) {
        final newsId = state.extra?.toString() ?? '';
        return buildAnimatedPage(
          child: BlocProvider(
            create: (_) => NewsController()..getNewsDetails(id: newsId),
            child: const NewsDetailsScreen(),
          ),
          transition: rotateY,
        );
      },
    ),
    GoRoute(
      name: RoutesName.viewAllServicesScreen,
      path: RoutesName.viewAllServicesScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: BlocProvider(
          create: (_) => HomeController(),
          child: const ViewAllServicesScreen(),
        ),
        transition: zoomFadeIn,
      ),
    ),
    GoRoute(
      name: RoutesName.financeScreen,
      path: RoutesName.financeScreen,
      pageBuilder: (context, state) => buildAnimatedPage(
        child: const FinanceScreen(),
        transition: slideFromBottom,
      ),
    ),
  ],
);
