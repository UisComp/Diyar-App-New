import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_grid_view_for_services.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_service_and_view_all_texts.dart';
import 'package:diyar_app/feature/home/view/widgets/diyar_banner_slider.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
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
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    homeController = HomeController.get(context);
    initHomeData();
  }

  Future<void> initHomeData() async {
    await homeController.getAllServices();
    await homeController.getAllAnnouncements();
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

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;

          AppFunctions.errorMessage(
            context,
            message: LocaleKeys.tap_again_to_exit.tr(),
          );

          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          titleAppBar: LocaleKeys.diyar.tr(),
          showIconNotification: true,
        ),
        body: SingleChildScrollView(
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
              BlocBuilder<HomeController, HomeState>(
                builder: (context, state) {
                  final isLoading =
                      state is GetAllAnnouncementsBannersLoadingState;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: DiyarBannerSlider(
                      isLoading:isLoading ,
                      banners: homeController.announcementsResponseModel,
                      height: 180.h,
                    ),
                  );
                },
              ),
              30.ph,
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
    );
  }
}
