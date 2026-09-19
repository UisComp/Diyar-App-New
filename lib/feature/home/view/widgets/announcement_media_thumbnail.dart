import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/youtube_player/announcement_youtube_player.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cover for an announcement in lists and the home carousel. Announcements
/// with a video get a play overlay and a "Video" badge; the player itself only
/// loads on the detail screen.
class AnnouncementMediaThumbnail extends StatelessWidget {
  const AnnouncementMediaThumbnail({
    super.key,
    required this.announcement,
    this.height,
  });

  final Announcement? announcement;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final item = announcement;
    final hasVideo = item?.hasVideo ?? false;

    final poster = item?.posterUrl;
    final Widget cover = poster == null
        ? const VideoPlaceholderBackground()
        : CustomCachedNetworkImage(
            imageUrl: poster,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            isProjectDetails: true,
          );

    if (!hasVideo) return cover;

    return Stack(
      fit: StackFit.expand,
      children: [
        cover,
        ColoredBox(color: AppColors.blackColor.withValues(alpha: 0.18)),
        Center(
          child: Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blackColor.withValues(alpha: 0.45),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.whiteColor,
              size: 28.sp,
            ),
          ),
        ),
        PositionedDirectional(
          top: 10.h,
          start: 10.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.smart_display_rounded,
                  color: AppColors.whiteColor,
                  size: 13.sp,
                ),
                4.pw,
                Text(
                  LocaleKeys.video.tr(),
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
