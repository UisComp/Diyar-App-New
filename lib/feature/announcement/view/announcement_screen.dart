import 'dart:ui' as ui;

import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeController()..getAllAnnouncements(),
      child: const _AnnouncementView(),
    );
  }
}

class _AnnouncementView extends StatelessWidget {
  const _AnnouncementView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(titleAppBar: LocaleKeys.announcements.tr()),
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          final controller = HomeController.get(context);
          final isLoading = state is GetAllAnnouncementsBannersLoadingState;
          final announcements =
              controller.announcementsResponseModel.data ?? [];

          if (!isLoading && announcements.isEmpty) {
            return _EmptyAnnouncements(isDark: isDark);
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => controller.getAllAnnouncements(),
            child: Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                separatorBuilder: (_, _) => 14.ph,
                itemCount: isLoading ? 4 : announcements.length,
                itemBuilder: (context, index) {
                  final item = isLoading ? null : announcements[index];
                  return _AnnouncementCard(item: item, isDark: isDark);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.item, required this.isDark});
  final Announcement? item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.whiteColor;
    final borderColor = isDark
        ? const Color(0xFF1F242B)
        : AppColors.primaryColor.withValues(alpha: 0.08);
    final descColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () {
        if (item != null) {
          context.push(RoutesName.imagePreviewScreen, extra: item);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              child: SizedBox(
                height: 160.h,
                width: double.infinity,
                child: CustomCachedNetworkImage(
                  imageUrl: item?.url ?? '',
                  fit: BoxFit.cover,
                  isProjectDetails: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item?.title ?? '',
                    style: AppStyle.fontSize18Bold(context).copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((item?.description ?? '').isNotEmpty) ...[
                    6.ph,
                    AppText(
                      item?.description ?? '',
                      style: AppStyle.fontSize14Regular(context).copyWith(
                        color: descColor,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  10.ph,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppText(
                          LocaleKeys.announcement_details.tr(),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Directionality.of(context) == ui.TextDirection.rtl
                            ? Icons.chevron_left_rounded
                            : Icons.chevron_right_rounded,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAnnouncements extends StatelessWidget {
  const _EmptyAnnouncements({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withValues(alpha: 0.08),
            ),
            child: Icon(
              Icons.campaign_outlined,
              size: 56.sp,
              color: AppColors.primaryColor,
            ),
          ),
          20.ph,
          AppText(
            LocaleKeys.announcements.tr(),
            style: AppStyle.fontSize18Bold(context),
          ),
          8.ph,
          AppText(
            LocaleKeys.no_image_found.tr(),
            style: AppStyle.fontSize14Regular(context).copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
