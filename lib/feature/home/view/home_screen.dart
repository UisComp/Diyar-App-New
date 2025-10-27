import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_grid_view_for_services.dart';
import 'package:diyar_app/feature/home/view/widgets/custom_service_and_view_all_texts.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    homeController.getAllServices();
    homeController.searchController.addListener(() {
      homeController.filterServices();
    });
  }

  final List<BannerItem> dummyBanners = [
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1560184897-67f4f3c18d55?w=800',
      title: 'Modern Villas for Rent',
      description: 'Discover luxury villas with private gardens and pools.',
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
      title: 'Apartments with Sea View',
      description: 'Wake up every day to stunning coastal views.',
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1599423300746-b62533397364?w=800',
      title: 'Affordable Family Homes',
      description: 'Find cozy and comfortable homes for your family.',
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=800',
      title: 'Smart Units Available',
      description: 'Experience modern living with smart home technology.',
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
      title: 'New Residential Projects',
      description: 'Be the first to explore the latest housing communities.',
    ),
  ];

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
              Text(
                "Discover",
                style: AppStyle.fontSize22Bold(context).copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor,
                ),
              ).paddingSymmetric(horizontal: 22.sp),
              10.ph,
              DiyarBannerSlider(banners: dummyBanners, height: 180.h),
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

class BannerItem {
  final String imageUrl;
  final String title;
  final String description;

  BannerItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class DiyarBannerSlider extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;

  const DiyarBannerSlider({
    super.key,
    required this.banners,
    this.height = 150.0,
  });

  @override
  State<DiyarBannerSlider> createState() => _DiyarBannerSliderState();
}

class _DiyarBannerSliderState extends State<DiyarBannerSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>showImagePreview(context, widget.banners[_current].imageUrl ) ,
      child: CarouselSlider.builder(
        itemCount: widget.banners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = widget.banners[index];
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomCachedNetworkImage(
                        imageUrl: banner.imageUrl,
                        height: widget.height.h,
                        fit: BoxFit.cover,
                        isProjectDetails: false,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                child: DotsIndicator(
                  dotsCount: widget.banners.length,
                  position: _current.toDouble(),
                  decorator: DotsDecorator(
                    spacing: EdgeInsets.symmetric(horizontal: 4.w),
                    activeColor: AppColors.primaryColor,
                    color: Colors.white.withOpacity(0.5),
                    size: Size(8.w, 8.h),
                    activeSize: Size(10.w, 10.h),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          height: widget.height.h,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          onPageChanged: (index, reason) {
            setState(() => _current = index);
          },
        ),
      ),
    );
  }
}
