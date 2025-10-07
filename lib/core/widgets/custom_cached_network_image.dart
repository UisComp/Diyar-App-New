import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fadeOutDuration: const Duration(seconds: 5),
      fadeInCurve: Curves.decelerate,
      fadeInDuration: const Duration(seconds: 5),
      imageUrl: imageUrl ?? '',
      fit: BoxFit.cover,
      placeholder: (context, url) => Skeletonizer.zone(
        enabled: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          Icon(Icons.broken_image, size: 40.sp, color: AppColors.greyColor),
    );
  }
}
