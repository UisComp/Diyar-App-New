
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildShimmerItem extends StatelessWidget {
  const BuildShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16.h,
                color: Colors.grey.shade300,
              ),
              8.ph,
              Container(
                width: double.infinity,
                height: 14.h,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        10.pw,
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
