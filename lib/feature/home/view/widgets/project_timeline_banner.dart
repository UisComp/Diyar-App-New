import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Full-width feature banner that opens the user's project timeline.
class ProjectTimelineBanner extends StatelessWidget {
  const ProjectTimelineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () {
        if (userModel?.data?.accessToken == null) {
          AppFunctions.warningMessage(
            context,
            message: LocaleKeys.available_for_logged_in_users_only.tr(),
          );
          return;
        }
        context.push(RoutesName.projectTimeline);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          gradient: AppColors.brandHeaderGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 54.w,
              width: 54.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.timeline_rounded,
                color: AppColors.whiteColor,
                size: 30.sp,
              ),
            ),
            14.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    LocaleKeys.project_timeline.tr(),
                    style: AppStyle.fontSize22Bold(context).copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.whiteColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.ph,
                  AppText(
                    LocaleKeys.project_timeline_subtitle.tr(),
                    style: AppStyle.fontSize16Regular(context).copyWith(
                      fontSize: 12.sp,
                      color: AppColors.whiteColor.withValues(alpha: 0.85),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            10.pw,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.whiteColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
