import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// Inline placeholder for a section with nothing to show: an animated
/// illustration (or icon), a title, an optional hint and an optional retry.
///
/// Fades and slides in so swapping from a skeleton doesn't feel abrupt.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.illustrationSize,
    this.boxed = true,
  });

  /// Error variant: cloud icon and a retry button.
  const EmptyStateView.error({
    super.key,
    required this.message,
    required this.onRetry,
    this.illustrationSize,
    this.boxed = true,
  }) : title = LocaleKeys.something_went_wrong,
       icon = Icons.cloud_off_rounded;

  /// Locale key for the headline.
  final String title;

  /// Already-translated supporting text.
  final String? message;

  /// Shown instead of the default empty-state animation.
  final IconData? icon;
  final VoidCallback? onRetry;
  final double? illustrationSize;

  /// Wraps the content in a subtle card so it reads as part of a section.
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final size = illustrationSize ?? 110.r;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: size * 0.3, color: AppColors.primaryColor),
          )
        else
          Lottie.asset(
            Assets.images.emptyRealState,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        12.ph,
        Text(
          title.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: surface.textPrimary,
          ),
        ),
        if (message != null) ...[
          6.ph,
          Text(
            message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.4,
              color: surface.textSecondary,
            ),
          ),
        ],
        if (onRetry != null) ...[
          14.ph,
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text(LocaleKeys.try_again.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: BorderSide(
                color: AppColors.primaryColor.withValues(alpha: 0.4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              textStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - t)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: boxed
            ? BoxDecoration(
                color: surface.subtle,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: surface.border),
              )
            : null,
        child: content,
      ),
    );
  }
}
