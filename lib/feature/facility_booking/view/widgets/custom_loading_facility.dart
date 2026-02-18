
import 'package:diyar_app/core/extension/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomLoadingFacility extends StatelessWidget {
  const CustomLoadingFacility({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, _) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16.w);
  }
}