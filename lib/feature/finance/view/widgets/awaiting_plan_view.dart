import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown instead of zeros for a unit whose payment plan staff haven't built
/// yet. Its `remaining_balance` is not money owed, so nothing is shown.
class AwaitingPlanView extends StatelessWidget {
  const AwaitingPlanView({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final icon = Container(
      width: (compact ? 40 : 64).r,
      height: (compact ? 40 : 64).r,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.hourglass_top_rounded,
        color: AppColors.primaryColor,
        size: (compact ? 20 : 30).sp,
      ),
    );
    final title = Text(
      LocaleKeys.payment_plan_being_prepared.tr(),
      textAlign: compact ? TextAlign.start : TextAlign.center,
      style: TextStyle(
        fontSize: (compact ? 14 : 16).sp,
        fontWeight: FontWeight.w700,
        color: surface.textPrimary,
      ),
    );
    final description = Text(
      LocaleKeys.payment_plan_being_prepared_desc.tr(),
      textAlign: compact ? TextAlign.start : TextAlign.center,
      style: TextStyle(
        fontSize: (compact ? 12 : 13).sp,
        color: surface.textSecondary,
        height: 1.4,
      ),
    );

    if (compact) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: surface.subtle,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            icon,
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, 2.ph, description],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: surface.cardDecoration(),
      child: Column(children: [icon, 14.ph, title, 6.ph, description]),
    );
  }
}
