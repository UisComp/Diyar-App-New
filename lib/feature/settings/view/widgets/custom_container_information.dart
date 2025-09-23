
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomContainerInformation extends StatelessWidget {
  const CustomContainerInformation({
    super.key,
    required this.titleContainer,
    required this.descriptionContainer,
    required this.svgIcon, this.onTap,
  });
  final String titleContainer;
  final String descriptionContainer;
  final String svgIcon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                color: AppColors.containerColor,
              ),
              child: SvgPicture.asset(
                svgIcon,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.scaleDown,
              ),
            ),
            12.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleContainer,
                  style: AppStyle.fontSize22BoldNewsReader.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                5.ph,
                Text(
                  descriptionContainer,
                  style: AppStyle.fontSize14RegularNewsReader.copyWith(
                    color: AppColors.descContainerColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16.w),
    );
  }
}