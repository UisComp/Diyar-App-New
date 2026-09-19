import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_grid_view_for_services.dart';
import 'package:diyar_app/feature/home/view/widgets/diyar_banner_slider.dart';
import 'package:diyar_app/feature/home/view/widgets/home_header.dart';
import 'package:diyar_app/feature/home/view/widgets/home_section_header.dart';
import 'package:diyar_app/feature/home/view/widgets/project_timeline_banner.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:diyar_app/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController homeController;
  late NotificationController notificationController;
  DateTime? lastPressed;

  /// Services shown on Home before "View All".
  static const _homeServicesLimit = 6;

  @override
  void initState() {
    super.initState();
    homeController = HomeController.get(context);
    notificationController = NotificationController.get(context);
    homeController.searchController.addListener(_onSearchChanged);
    _loadHome();
  }

  Future<void> _loadHome() async {
    await Future.wait([
      homeController.loadHome(),
      if (enableNotifications == true && userModel?.data?.accessToken != null)
        notificationController.fetchAllNotifications(),
    ]);
  }

  void _onSearchChanged() => homeController.filterServices();

  @override
  void dispose() {
    homeController.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeController, AppThemeState>(
      builder: (context, state) {
        final darkTheme =
            AppThemeController.get(context).currentThemeMode ==
            AppThemeMode.dark;
        final cardColor = darkTheme ? AppColors.black87 : AppColors.whiteColor;
        final cardImageColor = darkTheme
            ? AppColors.black87
            : AppColors.secondaryColor;
        final textColor = darkTheme
            ? AppColors.containerColor
            : AppColors.black87;
        return WillPopScope(
          onWillPop: () async {
            final now = DateTime.now();
            if (lastPressed == null ||
                now.difference(lastPressed!) > const Duration(seconds: 2)) {
              lastPressed = now;
              AppFunctions.warningMessage(
                context,
                message: LocaleKeys.tap_again_to_exit.tr(),
              );
              return false;
            }
            return true;
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  HomeHeader(darkTheme: darkTheme),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.primaryColor.withValues(alpha: 0.06),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: _loadHome,
                      child: BlocBuilder<HomeController, HomeState>(
                        builder: (context, homeState) {
                          final isSearching = homeController
                              .searchController
                              .text
                              .trim()
                              .isNotEmpty;
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                            children: [
                              _searchField(darkTheme, isSearching),
                              if (isSearching)
                                ..._searchResults(
                                  cardColor,
                                  cardImageColor,
                                  textColor,
                                )
                              else
                                ..._sections(
                                  cardColor,
                                  cardImageColor,
                                  textColor,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _searchField(bool darkTheme, bool isSearching) {
    return CustomTextFormField(
      controller: homeController.searchController,
      hintStyle: AppStyle.fontSize16Regular(context).copyWith(
        color: darkTheme
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        fontSize: 14.sp,
      ),
      hintText: LocaleKeys.search_services.tr(),
      prefixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SvgPicture.asset(
          Assets.images.svg.search,
          height: 20.h,
          width: 20.w,
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: isSearching
          ? IconButton(
              icon: Icon(Icons.close_rounded, size: 20.sp),
              onPressed: () {
                homeController.searchController.clear();
                FocusScope.of(context).unfocus();
              },
            )
          : null,
    );
  }

  List<Widget> _searchResults(
    Color cardColor,
    Color cardImageColor,
    Color textColor,
  ) {
    return [
      24.ph,
      HomeSectionHeader(
        title: LocaleKeys.search_results.tr(),
      ).paddingSymmetric(horizontal: 16.w),
      14.ph,
      CustomGridViewForServices(
        cardColor: cardColor,
        cardImageColor: cardImageColor,
        textColor: textColor,
      ),
    ];
  }

  List<Widget> _sections(
    Color cardColor,
    Color cardImageColor,
    Color textColor,
  ) {
    final banners = homeController.announcementsResponseModel.data ?? [];
    // Discover is promotional: hide it entirely rather than show an empty or
    // error box when there are no announcements.
    final showDiscover =
        homeController.isAnnouncementsLoading || banners.isNotEmpty;
    final hasServices =
        !homeController.isServicesLoading &&
        homeController.homeServices.isNotEmpty;

    return [
      AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: showDiscover
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.ph,
                  HomeSectionHeader(
                    title: LocaleKeys.discover.tr(),
                  ).paddingSymmetric(horizontal: 16.w),
                  14.ph,
                  DiyarBannerSlider(
                    isLoading: homeController.isAnnouncementsLoading,
                    banners: homeController.announcementsResponseModel,
                    height: 180.h,
                  ),
                ],
              )
            : const SizedBox(width: double.infinity),
      ),
      24.ph,
      const ProjectTimelineBanner().paddingSymmetric(horizontal: 16.w),
      28.ph,
      HomeSectionHeader(
        title: LocaleKeys.services.tr(),
        actionLabel: hasServices ? LocaleKeys.view_all.tr() : null,
        onAction: () => context.push(RoutesName.viewAllServicesScreen),
      ).paddingSymmetric(horizontal: 16.w),
      14.ph,
      CustomGridViewForServices(
        cardColor: cardColor,
        cardImageColor: cardImageColor,
        textColor: textColor,
        maxItems: _homeServicesLimit,
      ),
      32.ph,
      const DesignedByFooter(showLogo: true),
    ];
  }
}
