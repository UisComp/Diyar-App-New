import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandLogoHeader extends StatelessWidget {
  const BrandLogoHeader({
    super.key,
    this.height,
    this.logoHeight,
    this.borderRadius = 0,
  });

  final double? height;
  final double? logoHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = height ?? 300.h;
    final double resolvedLogoHeight = logoHeight ?? resolvedHeight * 0.55;
    final radius = BorderRadius.vertical(
      bottom: Radius.circular(borderRadius.r),
    );

    return ClipRRect(
      borderRadius: borderRadius == 0 ? BorderRadius.zero : radius,
      child: Container(
        height: resolvedHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.brandHeaderGradient,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.logoGlowGradient,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppColors.accentGradient,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Assets.images.appLogo.image(
                height: resolvedLogoHeight,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
