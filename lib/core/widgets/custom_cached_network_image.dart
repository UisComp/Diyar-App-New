import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/zoomable_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A cached network image that, by default, opens full screen and zoomable
/// when tapped. Set [enablePreview] to false where the tap belongs to
/// something else (a row that navigates, a video poster, a map layer).
class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.enablePreview = true,
    this.previewImages,
    this.previewIndex = 0,
    this.previewTitle,
    this.previewDescription,
    this.placeholderIcon,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  /// Whether tapping opens the full-screen zoomable viewer.
  final bool enablePreview;

  /// The gallery the preview pages through. Defaults to [imageUrl] alone.
  final List<String?>? previewImages;

  /// Which entry of [previewImages] this widget shows.
  final int previewIndex;
  final String? previewTitle;
  final String? previewDescription;

  /// Shown instead of the default picture glyph when there is no image.
  final IconData? placeholderIcon;

  bool get _hasUrl => imageUrl != null && imageUrl!.trim().isNotEmpty;

  List<String?> get _gallery => previewImages ?? [imageUrl];

  @override
  Widget build(BuildContext context) {
    final Widget content = !_hasUrl
        ? _buildFallback()
        : CachedNetworkImage(
            width: width,
            height: height,
            // Short enough that the picture is simply "there"; the old
            // 5-second crossfade read as images never loading.
            fadeInDuration: const Duration(milliseconds: 180),
            fadeOutDuration: const Duration(milliseconds: 120),
            fadeInCurve: Curves.easeOut,
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

    if (!enablePreview || !_hasUrl) return content;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => openImageViewer(
          context,
          images: _gallery,
          initialIndex: previewIndex,
          title: previewTitle,
          description: previewDescription,
        ),
        child: content,
      ),
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
        placeholderIcon ?? Icons.image_outlined,
        size: 38.sp,
        color: AppColors.primaryColor.withValues(alpha: 0.55),
      ),
    );
  }
}
