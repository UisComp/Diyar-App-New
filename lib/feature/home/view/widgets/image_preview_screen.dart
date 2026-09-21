import 'dart:ui' as ui;

import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/youtube_player/announcement_youtube_player.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/home/view/widgets/announcement_media_thumbnail.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Announcement details, read top to bottom as three separate blocks: the
/// image on its own, then the title and text, then the video when there is
/// one. The image is never reduced to a player poster — an announcement that
/// has both shows both.
class AnnouncementImagePreviewScreen extends StatelessWidget {
  const AnnouncementImagePreviewScreen({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final title = announcement.title ?? '';
    final description = announcement.description ?? '';
    final imageUrl = announcement.imageUrl;
    final videoId = announcement.youtubeVideoId;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (imageUrl != null)
                  _HeaderImage(
                    imageUrl: imageUrl,
                    hasVideo: videoId != null,
                    title: title,
                    description: description,
                  )
                else
                  const _HeaderBar(),
                _DetailsCard(
                  isDark: isDark,
                  title: title,
                  description: description,
                ),
                if (videoId != null)
                  _VideoSection(
                    isDark: isDark,
                    videoId: videoId,
                    watchUrl: announcement.youtubeUrl ?? '',
                    posterUrl: announcement.youtubeThumbnailUrl,
                  ),
                24.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The announcement image, shown for itself. The video badge stays so the
/// video further down is expected before it's scrolled to.
class _HeaderImage extends StatelessWidget {
  const _HeaderImage({
    required this.imageUrl,
    required this.hasVideo,
    this.title,
    this.description,
  });
  final String imageUrl;
  final bool hasVideo;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
          child: SizedBox(
            width: double.infinity,
            height: 300.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'announcement_$imageUrl',
                  child: CustomCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    previewTitle: title,
                    previewDescription: description,
                  ),
                ),
                // Only enough of a wash at the very top for the round buttons
                // to stay readable on a bright image.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.blackColor.withValues(alpha: 0.32),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const _HeaderBar(),
        if (hasVideo)
          PositionedDirectional(
            bottom: 18.h,
            end: 16.w,
            child: const AnnouncementVideoBadge(),
          ),
      ],
    );
  }
}

/// Back and close, over the image or on the plain background.
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Directionality.of(context) == ui.TextDirection.rtl
                ? Icons.arrow_forward_rounded
                : Icons.arrow_back_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          _CircleIconButton(
            icon: Icons.close_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}

/// Title and body text, on their own card between the image and the video.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.isDark,
    required this.title,
    required this.description,
  });
  final bool isDark;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.whiteColor;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final dividerColor = isDark
        ? const Color(0xFF1F242B)
        : AppColors.primaryColor.withValues(alpha: 0.10);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: dividerColor),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.campaign_rounded,
                      size: 14.sp,
                      color: AppColors.whiteColor,
                    ),
                    6.pw,
                    AppText(
                      LocaleKeys.announcement_details.tr(),
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (title.isNotEmpty) ...[
              16.ph,
              AppText(
                title.capitalize(),
                style: AppStyle.fontSize22Bold(context).copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
            if (description.isNotEmpty) ...[
              16.ph,
              Container(height: 1, color: dividerColor),
              16.ph,
              AppText(
                description,
                style: AppStyle.fontSize16Regular(context).copyWith(
                  color: secondaryText,
                  fontSize: 14.sp,
                  height: 1.7,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The video, as its own labelled block under the text. Its poster is
/// YouTube's own thumbnail, not the announcement image, so the two blocks
/// never look like the same picture twice.
class _VideoSection extends StatelessWidget {
  const _VideoSection({
    required this.isDark,
    required this.videoId,
    required this.watchUrl,
    required this.posterUrl,
  });
  final bool isDark;
  final String videoId;
  final String watchUrl;
  final String? posterUrl;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? const Color(0xFF1F242B)
        : AppColors.primaryColor.withValues(alpha: 0.10);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.smart_display_rounded,
                  size: 17.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              10.pw,
              AppText(
                LocaleKeys.video.tr(),
                style: AppStyle.fontSize18Bold(
                  context,
                ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          12.ph,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderColor),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: AnnouncementYoutubePlayer(
                videoId: videoId,
                watchUrl: watchUrl,
                posterUrl: posterUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blackColor.withValues(alpha: 0.5),
            border: Border.all(
              color: AppColors.whiteColor.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(icon, color: AppColors.whiteColor, size: 20.sp),
        ),
      ),
    );
  }
}
