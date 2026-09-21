import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A unit's pictures: the main one large, the rest as a thumbnail strip.
/// Every picture opens the full-screen zoomable viewer on the whole set.
///
/// With no pictures it shows a neutral placeholder, so a unit never looks
/// like it failed to load — unless [showWhenEmpty] is false.
class UnitImageGallery extends StatelessWidget {
  const UnitImageGallery({
    super.key,
    required this.images,
    this.title,
    this.height,
    this.showWhenEmpty = true,
    this.showHint = true,
  });

  /// Main image first, then the gallery (`UnitSummary.images` and friends).
  final List<String> images;

  /// Caption shown under the image in the full-screen viewer.
  final String? title;
  final double? height;
  final bool showWhenEmpty;

  /// The "tap to zoom" line, worth showing once per screen.
  final bool showHint;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final mainHeight = height ?? 190.h;

    if (images.isEmpty) {
      if (!showWhenEmpty) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        height: mainHeight,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: surface.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 40.sp,
              color: AppColors.primaryColor.withValues(alpha: 0.5),
            ),
            8.ph,
            Text(
              LocaleKeys.no_image_found.tr(),
              style: TextStyle(fontSize: 13.sp, color: surface.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            children: [
              CustomCachedNetworkImage(
                imageUrl: images.first,
                width: double.infinity,
                height: mainHeight,
                fit: BoxFit.cover,
                previewImages: images,
                previewTitle: title,
                placeholderIcon: Icons.home_work_outlined,
              ),
              PositionedDirectional(
                bottom: 8.h,
                end: 8.w,
                child: IgnorePointer(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black54Color,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.zoom_out_map_rounded,
                          size: 13.sp,
                          color: AppColors.whiteColor,
                        ),
                        if (images.length > 1) ...[
                          5.pw,
                          Text(
                            '${images.length}',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (images.length > 1) ...[
          8.ph,
          SizedBox(
            height: 62.r,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => 8.pw,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CustomCachedNetworkImage(
                  imageUrl: images[index],
                  width: 62.r,
                  height: 62.r,
                  fit: BoxFit.cover,
                  previewImages: images,
                  previewIndex: index,
                  previewTitle: title,
                  placeholderIcon: Icons.home_work_outlined,
                ),
              ),
            ),
          ),
        ],
        if (showHint) ...[
          6.ph,
          Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 13.sp,
                color: surface.textSecondary,
              ),
              5.pw,
              Expanded(
                child: Text(
                  LocaleKeys.tap_to_zoom.tr(),
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: surface.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
