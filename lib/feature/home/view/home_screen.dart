import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_grid_view_for_services.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_service_and_view_all_texts.dart';
import 'package:diyar_app/feature/home/view/widgets/diyar_banner_slider.dart';
import 'package:diyar_app/feature/home/view/widgets/home_header.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController homeController;
  late NotificationController notificationController;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    homeController = HomeController.get(context);
    notificationController = NotificationController.get(context);
    initHomeData();
  }

  Future<void> initHomeData() async {
    await homeController.getAllServices();
    await homeController.getAllAnnouncements();
    if (userModel?.data?.accessToken != null) {
      await notificationController.fetchAllNotifications();
    }
    homeController.searchController.addListener(() async {
      await homeController.filterServices();
    });
  }

  @override
  dispose() {
    homeController.searchController.removeListener(() {});
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
        return BlocBuilder<HomeController, HomeState>(
          builder: (context, homeState) {
            final isLoading =
                homeState is GetAllAnnouncementsBannersLoadingState ||
                homeState is GetAllServicesLoadingState;
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
                        child: Skeletonizer(
                          enabled: isLoading,
                          child: RefreshIndicator(
                            color: AppColors.primaryColor,
                            onRefresh: () async {
                              await homeController.getAllAnnouncements();
                              await homeController.getAllServices();
                              await homeController.filterServices();
                              if (enableNotifications == true &&
                                  userModel?.data?.accessToken != null) {
                                await notificationController
                                    .fetchAllNotifications();
                              }
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormField(
                                    controller: homeController.searchController,
                                    hintStyle:
                                        AppStyle.fontSize16Regular(context)
                                            .copyWith(
                                              color: darkTheme
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                        .lightTextSecondary,
                                              fontSize: 14.sp,
                                            ),
                                    hintText: LocaleKeys.search_services.tr(),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.images.svg.search,
                                        height: 22.h,
                                        width: 22.w,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ).paddingOnly(top: 16.h),
                                  20.ph,
                                  _sectionHeader(
                                    context,
                                    LocaleKeys.discover.tr(),
                                  ),
                                  5.ph,
                                  DiyarBannerSlider(
                                    isLoading: homeState
                                        is GetAllAnnouncementsBannersLoadingState,
                                    banners: homeController
                                        .announcementsResponseModel,
                                    height: 250.h,
                                  ),
                                  20.ph,
                                  const ProjectTimelineBanner()
                                      .paddingSymmetric(horizontal: 16.w),
                                  24.ph,
                                  const CustomServiceAndViewAllTexts(),
                                  20.ph,
                                  CustomGridViewForServices(
                                    cardColor: cardColor,
                                    cardImageColor: cardImageColor,
                                    textColor: textColor,
                                  ),
                                  20.ph,
                                  const DesignedByFooter(showLogo: true),
                                  16.ph,
                                ],
                              ),
                            ),
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
      },
    );
  }

  /// Section label with the brand accent bar, matching the Services header.
  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 22.h,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 10.w),
        AppText(
          title,
          style: AppStyle.fontSize22Bold(context).copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}
