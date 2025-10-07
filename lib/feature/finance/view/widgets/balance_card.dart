import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.all(16.0.sp),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.backgroundCard
              .image(width: double.infinity, fit: BoxFit.cover)
              .image,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          10.ph,
          Text(
            '\$12,345.67',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
          ),
        ],
      ),
    );
  }
}
