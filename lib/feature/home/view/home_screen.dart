import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_grid_view_for_services.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_service_and_view_all_texts.dart';
import 'package:diyar_app/feature/home/view/widgets/diyar_banner_slider.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:diyar_app/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
              child: Skeletonizer(
                enabled:
                    homeState is GetAllAnnouncementsBannersLoadingState ||
                    homeState is GetAllServicesLoadingState,
                child: Scaffold(
                  appBar: CustomAppBar(
                    actions: [
                      BlocBuilder<NotificationController, NotificationState>(
                        builder: (context, notificationState) {
                          final isLoading =
                              notificationState is NotificationLoading;
                          final isGuest = userModel?.data?.accessToken == null;

                          return Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (isGuest) {
                                    AppFunctions.warningMessage(
                                      context,
                                      message: LocaleKeys
                                          .notifications_for_logged_in_users_only
                                          .tr(),
                                    );
                                    return;
                                  }
                                  if (!isLoading) {
                                    context.push(
                                      RoutesName.notificationsScreen,
                                    );
                                  }
                                },
                                icon: isLoading
                                    ? SizedBox(
                                        height: 22.h,
                                        width: 22.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.redColor,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        Assets.images.svg.notification,
                                        color: isGuest
                                            ? AppColors.greyColor
                                            : darkTheme
                                            ? AppColors.whiteColor
                                            : AppColors.black87,
                                      ),
                              ),
                              if (!isGuest &&
                                  !isLoading &&
                                  notificationController.notifications?.data !=
                                      null &&
                                  (notificationController
                                              .notifications
                                              ?.data!
                                              .unreadNotificationsCount ??
                                          0) >
                                      0)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: EdgeInsets.all(2.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.redColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: AppText(
                                      '${notificationController.notifications?.data!.unreadNotificationsCount}',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                    titleAppBar: LocaleKeys.diyar.tr(),
                  ),
                  body: RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      await homeController.getAllAnnouncements();
                      await homeController.getAllServices();
                      await homeController.filterServices();
                      if (enableNotifications == true &&
                          userModel?.data?.accessToken != null) {
                        await notificationController.fetchAllNotifications();
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
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
                          Row(
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
                                LocaleKeys.discover.tr(),
                                style: AppStyle.fontSize22Bold(context).copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 16.w),
                          5.ph,
                          DiyarBannerSlider(
                            isLoading:
                                homeState
                                    is GetAllAnnouncementsBannersLoadingState,
                            banners: homeController.announcementsResponseModel,
                            height: 250.h,
                          ),
                          20.ph,
                          const CustomServiceAndViewAllTexts(),
                          20.ph,
                          CustomGridViewForServices(
                            cardColor: cardColor,
                            cardImageColor: cardImageColor,
                            textColor: textColor,
                          ),
                          30.ph,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
