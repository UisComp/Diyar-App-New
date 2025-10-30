import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiyarBannerSlider extends StatefulWidget {
  final AnnouncementsResponseModel banners;
  final double height;
  final bool isLoading;

  const DiyarBannerSlider({
    super.key,
    required this.banners,
    this.isLoading = false,
    this.height = 150.0,
  });

  @override
  State<DiyarBannerSlider> createState() => _DiyarBannerSliderState();
}

class _DiyarBannerSliderState extends State<DiyarBannerSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.isLoading ? 3 : (widget.banners.data?.length ?? 0);
    return InkWell(
      onTap: () => showImagePreview(
        context,
        widget.banners.data?[_current].url ?? '',
        title: widget.banners.data?[_current].title,
        description: widget.banners.data?[_current].description,
      ),
      child: CarouselSlider.builder(
        itemCount: itemCount,
        itemBuilder: (context, index, realIndex) {
          final banner = widget.isLoading ? null : widget.banners.data?[index];
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
                      Skeleton.replace(
                        child: CustomCachedNetworkImage(
                          imageUrl: banner?.url ?? '',
                          height: widget.height.h,
                          fit: BoxFit.cover,
                          isProjectDetails: false,
                        ),
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
              if (!widget.isLoading)
                Positioned(
                  bottom: 10.h,
                  child: DotsIndicator(
                    dotsCount: itemCount,
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
