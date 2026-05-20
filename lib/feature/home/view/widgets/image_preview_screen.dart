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

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320.h,
            pinned: true,
            stretch: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: backgroundColor,
            systemOverlayStyle: isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            leading: _CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.maybePop(context),
            ),
            actions: [
              _CircleIconButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
              12.pw,
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
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
                          AppColors.blackColor.withValues(alpha: 0.45),
                          Colors.transparent,
                          backgroundColor.withValues(alpha: 0.0),
                          backgroundColor,
                        ],
                        stops: const [0.0, 0.35, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -24.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: dividerColor),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.blackColor.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AppText(
                        LocaleKeys.announcement_details.tr(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    if (hasTitle) ...[
                      14.ph,
                      AppText(
                        title!.capitalize(),
                        style: AppStyle.fontSize22Bold(context).copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                    if (hasDescription) ...[
                      14.ph,
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              dividerColor,
                              dividerColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                      16.ph,
                      AppText(
                        description!,
                        style: AppStyle.fontSize16Regular(context).copyWith(
                          color: secondaryText,
                          fontSize: 14.sp,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blackColor.withValues(alpha: 0.45),
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
      ),
    );
  }
}
