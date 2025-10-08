import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EventItem extends StatelessWidget {
  final int newsId;
  final String title;
  final String description;
  final String imageUrl;

  const EventItem({
    super.key,
    required this.newsId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          RoutesName.newsDetailsScreen,
          extra: newsId, 
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.fontSize18Bold(
                    context,
                  ).copyWith(fontSize: 16.sp),
                ),
                4.ph,
                Text(
                  description,
                  style: AppStyle.fontSize16Regular(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          10.pw,
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CustomCachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: imageUrl,
              width: 100.w,
              height: 100.h,
            ),
          ),
        ],
      ),
    );
  }
}
