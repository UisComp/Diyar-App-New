import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.news.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder:
                      (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                      ) => Assets.images.diyarNativeSplash.image(
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                  options: CarouselOptions(
                    viewportFraction: 0.8,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DotsIndicator(
                    dotsCount: 4,
                    position: _currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      activeColor: AppColors.whiteColor,
                      color: AppColors.greyColor,
                      size: const Size(15, 15),
                      activeSize: const Size(15, 15),
                      spacing: const EdgeInsets.all(4),
                    ),
                  ),
                ),
              ],
            ),
            30.ph,
            Text(
              'Diyar Al Muharraq Announces Completion of Phase 1',
              style: AppStyle.fontSize22Bold,
            ),
            16.ph,
            Text(
              '2024-06-27',
              style: AppStyle.fontSize14RegularNewsReader.copyWith(
                color: AppColors.descContainerColor,
                fontSize: 16.sp,
              ),
            ),
            16.ph,

            Text(
              "Diyar Al Muharraq, a leading urban developer in Bahrain, has announced the successful completion of Phase 1 of its flagship project, marking a significant milestone in the development of this integrated city. The phase includes the completion of key infrastructure, residential units, and commercial spaces, setting the stage for future growth and expansion.",
              style: AppStyle.fontSize14RegularNewsReader.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }
}
