
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEmergencyNumberButton extends StatelessWidget {
  const CustomEmergencyNumberButton({
    super.key,
    required double holdProgress,
    required this.remainingSeconds,
  }) : _holdProgress = holdProgress;

  final double _holdProgress;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 160.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.redColor, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.redColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: _holdProgress * 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.whiteColor,
            size: 40.sp,
          ),
          8.ph,
          Text("${remainingSeconds}s", style: AppStyle.fontSize22Bold(context)),
        ],
      ),
    );
  }
}
