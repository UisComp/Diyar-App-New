
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OuterContainer extends StatelessWidget {
  const OuterContainer({
    super.key,
    required double holdProgress,
    required this.isDark,
  }) : _holdProgress = holdProgress;

  final double _holdProgress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: CircularProgressIndicator(
        value: _holdProgress,
        strokeWidth: 12,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.redColor),
        backgroundColor: isDark ? Colors.white12 : Colors.black12,
      ),
    );
  }
}