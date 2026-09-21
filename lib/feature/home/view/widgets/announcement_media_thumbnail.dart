import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/youtube_player/announcement_youtube_player.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cover for an announcement in lists and the home carousel.
///
/// The image is shown as-is, the way the promotion banners always were: no
/// scrim and no player chrome over it. An announcement that also carries a
/// video only gets a small badge in the corner, so people can tell there's
/// something to watch before they open it. The player itself lives on the
/// detail screen.
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
            enablePreview: false,
          );

    if (!hasVideo) return cover;

    return Stack(
      fit: StackFit.expand,
      children: [
        cover,
        PositionedDirectional(
          top: 10.h,
          start: 10.w,
          child: const AnnouncementVideoBadge(),
        ),
      ],
    );
  }
}

/// "Video" pill: the only hint the cover gives that a video is attached.
class AnnouncementVideoBadge extends StatelessWidget {
  const AnnouncementVideoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.blackColor.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14.w,
            height: 14.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFF0000),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.whiteColor,
              size: 11.sp,
            ),
          ),
          5.pw,
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
    );
  }
}
