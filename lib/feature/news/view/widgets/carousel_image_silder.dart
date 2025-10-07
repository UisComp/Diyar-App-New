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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: newsDetails?.media!.length,
          itemBuilder: (context, index, _) {
            return CustomCachedNetworkImage(
              imageUrl: newsDetails?.media![index].url,
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              newsController.changeCarouselIndex(index);
            },
          ),
        ),
        DotsIndicator(
          dotsCount: newsDetails?.media!.length ?? 0,
          position: newsController.currentIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: AppColors.primaryColor,
            color: AppColors.greyColor,
            size: Size(20.w, 20.h),
            activeSize: Size(20.w, 20.h),
          ),
        ),
      ],
    );
  }
}
