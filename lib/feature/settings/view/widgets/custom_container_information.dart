import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
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
  });

  final String titleContainer;
  final String descriptionContainer;
  final String? imageUrl;
  final String? svgIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w, 
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.containerColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: imageUrl != null
                    ? CustomCachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: 56.w,
                        height: 56.h,
                      )
                    : (svgIcon != null
                        ? Center(
                          child: SvgPicture.asset(
                              svgIcon!,
                              width: 28.w,
                              height: 28.h,
                              fit: BoxFit.scaleDown,
                            ),
                        )
                        : Icon(
                            Icons.image_outlined,
                            size: 28.sp,
                            color: AppColors.greyColor,
                          )),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleContainer,
                    style: AppStyle.fontSize22BoldNewsReader(context).copyWith(
                      fontSize: 18.sp
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.ph,
                  Text(
                    descriptionContainer,
                    style: AppStyle.fontSize14RegularNewsReader(context)
                        .copyWith(color: AppColors.greyColor),
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
