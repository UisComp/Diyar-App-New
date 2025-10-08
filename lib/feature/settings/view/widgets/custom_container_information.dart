import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
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
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                if (imageUrl != null) {
                  showImagePreview(context, imageUrl!);
                }
              },
              child: Container(
                width: width ?? 70.w,
                height: height ?? 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.containerColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: imageUrl != null
                      ? CustomCachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imageUrl!,
                          width: 60.w,
                          height: 60.h,
                        )
                      : (svgIcon != null
                            ? Center(
                                child: SvgPicture.asset(
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                  svgIcon!,
                                  width: 30.w,
                                  height: 30.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.image_outlined,
                                size: 28.sp,
                                color: AppColors.greyColor,
                              )),
                ),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleContainer,
                    style: AppStyle.fontSize22BoldNewsReader(
                      context,
                    ).copyWith(fontSize: 18.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (projectName != null && projectName!.isNotEmpty)
                    Text(
                      "(${projectName??''})",
                      style: AppStyle.fontSize22BoldNewsReader(
                        context,
                      ).copyWith(fontSize: 13.sp,fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  5.ph,
                  if (descriptionContainer.isNotEmpty)
                    Text(
                      descriptionContainer,
                      style: AppStyle.fontSize14RegularNewsReader(
                        context,
                      ).copyWith(color: AppColors.greyColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16.w),
    );
  }
}
