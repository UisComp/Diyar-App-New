import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselImageSilder extends StatelessWidget {
  const CarouselImageSilder({
    super.key,
    required this.newsDetails,
    required this.newsController,
  });

  final NewsDataDetails? newsDetails;
  final NewsController newsController;

  /// Width / height of the pictures (also the loading placeholder's).
  static const double aspectRatio = 4 / 3;

  @override
  Widget build(BuildContext context) {
    final media = newsDetails?.media ?? const [];
    // One picture (or none) stays still: no auto-play, no swiping onto a
    // looped copy of itself, no counter.
    final hasMany = media.length > 1;
    // The index outlives the article; the next one may have fewer pictures.
    final current = media.isEmpty
        ? 0
        : newsController.currentIndex.clamp(0, media.length - 1);
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: media.length,
          itemBuilder: (context, index, _) {
            return CustomCachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: media[index].url,
            );
          },
          options: CarouselOptions(
            aspectRatio: aspectRatio,
            viewportFraction: 1,
            autoPlay: hasMany,
            autoPlayInterval: const Duration(seconds: 4),
            enableInfiniteScroll: hasMany,
            scrollPhysics: hasMany
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              newsController.changeCarouselIndex(index);
            },
          ),
        ),
        if (hasMany)
          PositionedDirectional(
            bottom: 12.h,
            start: 0,
            end: 0,
            child: Center(
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: DotsIndicator(
                    dotsCount: media.length,
                    position: current.toDouble(),
                    decorator: DotsDecorator(
                      spacing: EdgeInsets.symmetric(horizontal: 3.w),
                      activeColor: AppColors.whiteColor,
                      color: AppColors.whiteColor.withValues(alpha: 0.5),
                      size: Size(6.r, 6.r),
                      activeSize: Size(18.r, 6.r),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
