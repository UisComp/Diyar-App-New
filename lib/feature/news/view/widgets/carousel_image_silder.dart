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

  @override
  Widget build(BuildContext context) {
    final media = newsDetails?.media ?? const [];
    // One picture (or none) stays still: no auto-play, no swiping onto a
    // looped copy of itself, no dots.
    final hasMany = media.length > 1;
    return Stack(
      alignment: Alignment.bottomCenter,
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
            aspectRatio: 1.2,
            viewportFraction: 1,
            autoPlay: hasMany,
            autoPlayInterval: const Duration(seconds: 3),
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
          DotsIndicator(
            dotsCount: media.length,
            // The index outlives the article; the next one may have fewer
            // pictures.
            position: newsController.currentIndex
                .clamp(0, media.length - 1)
                .toDouble(),
            decorator: DotsDecorator(
              spacing: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              activeColor: AppColors.primaryColor,
              color: AppColors.greyColor,
              size: Size(15.w, 15.h),
              activeSize: Size(15.w, 15.h),
            ),
          ),
      ],
    );
  }
}
