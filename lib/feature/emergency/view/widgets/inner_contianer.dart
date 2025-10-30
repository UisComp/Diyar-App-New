
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InnerContianer extends StatelessWidget {
  const InnerContianer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      height: 240.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.redAccent.withOpacity(0.6), Colors.transparent],
        ),
      ),
    );
  }
}