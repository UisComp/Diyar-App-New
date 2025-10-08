import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
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
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeController),
      ],
      child: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: _homeController.currentIndex,
                children: AppConstants.screens,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _homeController.currentIndex,
              onTap: (index) {
                _homeController.changeIndexBottomNavBar(index);
              },
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Assets.images.svg.settings,
                    colorFilter: ColorFilter.mode(
                      _homeController.currentIndex == 0
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
                      _homeController.currentIndex == 1
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
                      _homeController.currentIndex == 2
                          ? AppColors.primaryColor
                          : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: LocaleKeys.profile.tr(),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: _homeController.currentIndex == 2
                ? BlocProvider(
                    create: (context) => AuthController(),
                    child: BlocConsumer<AuthController, AuthState>(
                      listener: (context, authState) {
                        if (authState is LogOutSuccessState) {
                          AppFunctions.successMessage(
                            context,
                            message: context
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
                            message: context
                                    .read<AuthController>()
                                    .logoutResponseModel
                                    .message ??
                                LocaleKeys.logout_failure.tr(),
                          );
                        }
                      },
                      builder: (context, authState) {
                        final isLoading = authState is LogOutLoadingState;

                        return FloatingActionButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await context.read<AuthController>().logOut();
                                },
                          backgroundColor: AppColors.redColor,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.logout, color: Colors.white),
                        ).paddingOnly(bottom: 60.h, right: 16.w);
                      },
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
