import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late HomeController homeController;
  @override
  void initState() {
    super.initState();
    homeController = HomeController.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: homeController.currentIndex,
              children: AppConstants.screens,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: homeController.currentIndex,
            onTap: (index) {
              homeController.changeIndexBottomNavBar(index);
            },
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.images.svg.settings,
                  colorFilter: ColorFilter.mode(
                    homeController.currentIndex == 0
                        ? AppColors.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24.h,
                  width: 24.w,
                ),
                label: LocaleKeys.settings.tr(),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.images.svg.home,
                  colorFilter: ColorFilter.mode(
                    homeController.currentIndex == 1
                        ? AppColors.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: LocaleKeys.home.tr(),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.images.svg.person,
                  colorFilter: ColorFilter.mode(
                    homeController.currentIndex == 2
                        ? AppColors.primaryColor
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: LocaleKeys.profile.tr(),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: homeController.currentIndex == 2
              ? BlocProvider(
                  create: (context) => AuthController(),
                  child: BlocConsumer<AuthController, AuthState>(
                    listener: (context, authState) {
                      if (authState is LogOutSuccessState) {
                        AppFunctions.successMessage(
                          context,
                          message:
                              context
                                  .read<AuthController>()
                                  .logoutResponseModel
                                  .message ??
                              LocaleKeys.logout_successfully.tr(),
                        );
                        context.go(RoutesName.login);
                      }
                      if (authState is LogOutFailureState) {
                        AppFunctions.errorMessage(
                          context,
                          message:
                              context
                                  .read<AuthController>()
                                  .logoutResponseModel
                                  .message ??
                              LocaleKeys.logout_failure.tr(),
                        );
                      }
                    },
                    builder: (context, authState) {
                      return CustomButton(
                        isLoading: authState is LogOutLoadingState,
                        borderRadius: 12.r,
                        buttonText: LocaleKeys.logout.tr(),
                        onPressed: () async {
                          await context.read<AuthController>().logOut();
                        },
                        buttonColor: AppColors.redColor,
                      );
                    },
                  ),
                ).paddingOnly(bottom: 60.h, right: 16.w, left: 16.w)
              : null,
        );
      },
    );
  }
}
