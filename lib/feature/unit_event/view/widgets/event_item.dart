import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/relative_date.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EventItem extends StatelessWidget {
  final int newsId;
  final String title;
  final String description;
  final String imageUrl;

  /// `news_date` as the API sends it; shown as "3 days ago" and the like.
  final String? newsDate;

  const EventItem({
    super.key,
    required this.newsId,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.newsDate,
  });

  @override
  Widget build(BuildContext context) {
    final published = RelativeDate.format(
      newsDate,
      locale: context.locale.languageCode,
    );
    final secondary = AppSurface.of(context).textSecondary;
    return InkWell(
      onTap: () {
        context.push(RoutesName.newsDetailsScreen, extra: newsId);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              // Full width, so an Arabic title in the English app (or the
              // reverse) lines up on its own side rather than hugging ours.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  title,
                  style: AppStyle.fontSize18Bold(
                    context,
                  ).copyWith(fontSize: 16.sp),
                ),
                4.ph,
                AppText(
                  description,
                  style: AppStyle.fontSize16Regular(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (published != null) ...[
                  6.ph,
                  // The date is the app's, so it follows the app's
                  // direction rather than the article's.
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14.sp,
                        color: secondary,
                      ),
                      4.pw,
                      Flexible(
                        child: Text(
                          published,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.fontSize12Regular(
                            context,
                          ).copyWith(color: secondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          10.pw,
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CustomCachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              width: 100.w,
              height: 100.h,
              // The row opens the news item; the thumbnail must not swallow
              // that tap.
              enablePreview: false,
            ),
          ),
        ],
      ),
    );
  }
}
