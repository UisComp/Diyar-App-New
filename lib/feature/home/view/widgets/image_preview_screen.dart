import 'dart:ui' as ui;

import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnnouncementImagePreviewScreen extends StatelessWidget {
  const AnnouncementImagePreviewScreen({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
  });
  final String? imageUrl;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.whiteColor;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final dividerColor = isDark
        ? const Color(0xFF1F242B)
        : AppColors.primaryColor.withValues(alpha: 0.10);

    final hasTitle = title != null && title!.isNotEmpty;
    final hasDescription = description != null && description!.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderImage(
                  imageUrl: imageUrl,
                  backgroundColor: backgroundColor,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: dividerColor),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: AppColors.blackColor
                                    .withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.campaign_rounded,
                                  size: 14.sp,
                                  color: AppColors.whiteColor,
                                ),
                                6.pw,
                                AppText(
                                  LocaleKeys.announcement_details.tr(),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (hasTitle) ...[
                          16.ph,
                          AppText(
                            title!.capitalize(),
                            style: AppStyle.fontSize22Bold(context).copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.35,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                        if (hasDescription) ...[
                          16.ph,
                          Container(
                            height: 1,
                            color: dividerColor,
                          ),
                          16.ph,
                          AppText(
                            description!,
                            style: AppStyle.fontSize16Regular(context).copyWith(
                              color: secondaryText,
                              fontSize: 14.sp,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.imageUrl, required this.backgroundColor});
  final String? imageUrl;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28.r),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 300.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'announcement_${imageUrl ?? ''}',
                  child: CustomCachedNetworkImage(
                    isProjectDetails: true,
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.blackColor.withValues(alpha: 0.35),
                        Colors.transparent,
                        AppColors.blackColor.withValues(alpha: 0.12),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
          child: Row(
            children: [
              _CircleIconButton(
                icon: Directionality.of(context) == ui.TextDirection.rtl
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_back_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
              const Spacer(),
              _CircleIconButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blackColor.withValues(alpha: 0.5),
            border: Border.all(
              color: AppColors.whiteColor.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.whiteColor,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
