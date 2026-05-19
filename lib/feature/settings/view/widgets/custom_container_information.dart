import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomContainerInformation extends StatelessWidget {
  const CustomContainerInformation({
    super.key,
    required this.titleContainer,
    required this.descriptionContainer,
    this.imageUrl,
    this.onTap,
    this.svgIcon,
    this.width,
    this.height,
    this.projectName,
  });
  final String titleContainer;
  final String descriptionContainer;
  final String? imageUrl;
  final String? svgIcon;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final String? projectName;
  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeController.get(context).currentThemeMode ==
        AppThemeMode.dark;
    final Color cardBg = isDark ? const Color(0xFF111418) : AppColors.whiteColor;
    final Color borderColor =
        isDark ? const Color(0xFF1F242B) : const Color(0xFFE5E9F0);
    final Color iconBg = AppColors.primaryColor.withValues(alpha: 0.10);
    final Color titleColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color descColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14.r),
                onTap: () {
                  if (imageUrl != null) {
                    showImagePreview(context, imageUrl!);
                  }
                },
                child: Container(
                  width: width ?? 56.w,
                  height: height ?? 56.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    color: imageUrl != null ? AppColors.containerColor : iconBg,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: imageUrl != null
                        ? CustomCachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl!,
                            width: width ?? 56.w,
                            height: height ?? 56.h,
                          )
                        : (svgIcon != null
                            ? Center(
                                child: SvgPicture.asset(
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                  svgIcon!,
                                  width: 26.w,
                                  height: 26.h,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Icon(
                                Icons.image_outlined,
                                size: 26.sp,
                                color: AppColors.primaryColor,
                              )),
                  ),
                ),
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      titleContainer,
                      style: AppStyle.fontSize18Bold(context).copyWith(
                        fontSize: 16.sp,
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (projectName != null && projectName!.isNotEmpty)
                      AppText(
                        "(${projectName ?? ''})",
                        style: AppStyle.fontSize14Regular(context).copyWith(
                          fontSize: 12.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (descriptionContainer.isNotEmpty) ...[
                      4.ph,
                      AppText(
                        descriptionContainer,
                        style: AppStyle.fontSize14Regular(context).copyWith(
                          fontSize: 12.5.sp,
                          color: descColor,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                8.pw,
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16.w);
  }
}
