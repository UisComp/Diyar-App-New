import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.isProjectDetails = false,
    this.tintBrand = false,
  });
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isProjectDetails;
  final bool tintBrand;
  @override
  Widget build(BuildContext context) {
    final bool emptyUrl = imageUrl == null || imageUrl!.trim().isEmpty;
    final Widget content = emptyUrl
        ? _buildFallback()
        : CachedNetworkImage(
            width: width,
            height: height,
            fadeOutDuration: const Duration(seconds: 5),
            fadeInCurve: Curves.decelerate,
            fadeInDuration: const Duration(seconds: 5),
            imageUrl: imageUrl!,
            fit: fit ?? BoxFit.cover,
            placeholder: (context, url) => Skeletonizer.zone(
              enabled: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            errorWidget: (context, url, error) => _buildFallback(),
          );
    return InkWell(
      onTap: isProjectDetails
          ? null
          : () {
              if (imageUrl != null && imageUrl!.isNotEmpty) {
                showImagePreview(context, imageUrl!);
              }
            },
      child: tintBrand
          ? ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
              child: content,
            )
          : content,
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.10),
            AppColors.accentHoverColor.withValues(alpha: 0.04),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 38.sp,
        color: AppColors.primaryColor.withValues(alpha: 0.55),
      ),
    );
  }
}
