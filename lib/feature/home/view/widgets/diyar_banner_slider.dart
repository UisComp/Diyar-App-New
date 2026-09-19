import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/home/view/widgets/announcement_media_thumbnail.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Announcement carousel for the Discover section. The parent hides the
/// section when there's nothing to show, so this only handles the loading
/// skeleton and the populated slider.
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
    if (widget.isLoading) {
      return Skeletonizer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Bone(
            width: double.infinity,
            height: widget.height,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      );
    }

    final banners = widget.banners.data ?? [];
    if (banners.isEmpty) return const SizedBox.shrink();
    final current = _current.clamp(0, banners.length - 1);
    final hasMany = banners.length > 1;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return GestureDetector(
              onTap: () =>
                  context.push(RoutesName.imagePreviewScreen, extra: banner),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Hero(
                    tag: 'announcement_${banner.url ?? index}',
                    child: AnnouncementMediaThumbnail(
                      announcement: banner,
                      height: widget.height,
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            autoPlay: hasMany,
            autoPlayInterval: const Duration(seconds: 5),
            enableInfiniteScroll: hasMany,
            enlargeCenterPage: hasMany,
            enlargeFactor: 0.18,
            viewportFraction: hasMany ? 0.9 : 0.92,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
        ),
        if (hasMany) ...[
          SizedBox(height: 10.h),
          DotsIndicator(
            dotsCount: banners.length,
            position: current.toDouble(),
            decorator: DotsDecorator(
              spacing: EdgeInsets.symmetric(horizontal: 3.w),
              activeColor: AppColors.primaryColor,
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              size: Size(6.r, 6.r),
              activeSize: Size(18.r, 6.r),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
