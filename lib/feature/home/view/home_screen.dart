import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
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
    await notificationController.fetchAllNotifications();
    homeController.searchController.addListener(() async {
      await homeController.filterServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        AppThemeController.get(context).currentThemeMode == AppThemeMode.dark;
    final cardColor = darkTheme ? AppColors.black87 : AppColors.whiteColor;
    final cardImageColor = darkTheme
        ? AppColors.black87
        : AppColors.secondaryColor;
    final textColor = darkTheme ? AppColors.containerColor : AppColors.black87;

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

                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (!isLoading) {
                                context.push(RoutesName.notificationsScreen);
                              }
                            },
                            icon: isLoading
                                ? SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    Assets.images.svg.notification,
                                  ),
                          ),

                          /// badge
                          if (!isLoading &&
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
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${notificationController.notifications?.data!.unreadNotificationsCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
                  await notificationController.fetchAllNotifications();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: homeController.searchController,
                        hintStyle: AppStyle.fontSize16Regular(
                          context,
                        ).copyWith(color: AppColors.primaryColor),
                        hintText: LocaleKeys.search_services.tr(),
                        prefixIcon: SvgPicture.asset(
                          Assets.images.svg.search,
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                      ).paddingOnly(top: 20.h),
                      30.ph,
                      Text(
                        LocaleKeys.discover.tr(),
                        style: AppStyle.fontSize22Bold(context).copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ).paddingSymmetric(horizontal: 16.w),
                      5.ph,
                      DiyarBannerSlider(
                        isLoading:
                            homeState is GetAllAnnouncementsBannersLoadingState,
                        banners: homeController.announcementsResponseModel,
                        height: 180.h,
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
  }
}
