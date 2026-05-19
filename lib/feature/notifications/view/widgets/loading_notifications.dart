import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingNotifications extends StatelessWidget {
  const LoadingNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final Color skeleton = AppColors.primaryColor.withValues(alpha: 0.08);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E9F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: skeleton,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: skeleton,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                8.ph,
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: skeleton,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                6.ph,
                Container(
                  width: 120.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: skeleton,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w),
            child: Container(
              width: 22.sp,
              height: 22.sp,
              decoration: BoxDecoration(
                color: skeleton,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
