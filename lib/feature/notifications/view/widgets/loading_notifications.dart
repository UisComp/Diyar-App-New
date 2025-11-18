
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingNotifications extends StatelessWidget {
  const LoadingNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 50.w, height: 50.h, color: Colors.grey[400]),
          10.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: Colors.grey[400],
                ),
                4.ph,
                Container(
                  width: double.infinity,
                  height: 14.h,
                  color: Colors.grey[400],
                ),
                6.ph,
                Container(width: 120.w, height: 12.h, color: Colors.grey[400]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              width: 24.sp,
              height: 24.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
