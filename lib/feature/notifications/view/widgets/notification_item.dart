import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:diyar_app/feature/notifications/view/widgets/delete_notification_icon.dart';
import 'package:diyar_app/feature/notifications/view/widgets/loading_notifications.dart';
import 'package:diyar_app/feature/notifications/view/widgets/notification_time.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NotificationItem extends StatelessWidget {
  final NotificationData notification;
  final NotificationController notificationController;
  final bool isLoading;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.notificationController,
    this.isLoading = false,
  });

  String _getTitle(BuildContext context) {
    final isAr = context.locale == Locale(AppConstants.arLanguage);
    if (isAr) {
      return notification.titleAr?.isNotEmpty == true
          ? notification.titleAr!
          : notification.title ?? '';
    } else {
      return notification.title?.isNotEmpty == true
          ? notification.title!
          : notification.titleAr ?? '';
    }
  }

  String _getDescription(BuildContext context) {
    final isAr = context.locale == Locale(AppConstants.arLanguage);
    if (isAr) {
      return notification.descriptionAr?.isNotEmpty == true
          ? notification.descriptionAr!
          : notification.description ?? '';
    } else {
      return notification.description?.isNotEmpty == true
          ? notification.description!
          : notification.descriptionAr ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingNotifications();
    }
    final isRead = notification.isRead == true || notification.type == 'all';
    final isDark = AppThemeController.get(context).currentThemeMode ==
        AppThemeMode.dark;

    final Color cardBg = isRead
        ? (isDark ? const Color(0xFF111418) : AppColors.whiteColor)
        : AppColors.primaryColor.withValues(alpha: isDark ? 0.12 : 0.06);
    final Color borderColor = isRead
        ? (isDark ? const Color(0xFF1F242B) : const Color(0xFFE5E9F0))
        : AppColors.primaryColor.withValues(alpha: 0.35);
    final Color titleColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color descColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () async {
          if (notification.isRead == false &&
              notification.type != 'all' &&
              notification.entityType == null) {
            await notificationController.markAsRead(notification.id!);
          }

          if (notification.entityType == "1") {
            final controller = FacilityBookingController();
            await controller.getFacilityBookingHistory();
            notificationController.markAsRead(notification.id!);
            if (!context.mounted) return;
            context.push(
              RoutesName.facilityBookingHistoryScreen,
              extra: controller,
            );
          } else if (notification.entityType == "2") {
            final controller = ServiceProviderController();
            await controller.getServiceProviderHistory();
            notificationController.markAsRead(notification.id!);
            if (!context.mounted) return;
            context.push(
              RoutesName.serviceProviderHistoryScreen,
              extra: controller,
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(14.sp),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor, width: 1),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Leading(
                imageUrl: notification.imageUrl,
                isRead: isRead,
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isRead)
                          Container(
                            margin: EdgeInsetsDirectional.only(
                              top: 6.h,
                              end: 8.w,
                            ),
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              gradient: AppColors.accentGradient,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: AppText(
                            _getTitle(context),
                            style: AppStyle.fontSize16Regular(context).copyWith(
                              color: titleColor,
                              fontSize: 15.sp,
                              fontWeight:
                                  isRead ? FontWeight.w600 : FontWeight.w800,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    6.ph,
                    AppText(
                      _getDescription(context),
                      style: AppStyle.fontSize14Regular(context).copyWith(
                        color: descColor,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.ph,
                    NotificationTime(notification: notification),
                  ],
                ),
              ),
              if (notification.type != 'all')
                DeleteNotificationIcon(
                  notification: notification,
                  notificationController: notificationController,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.imageUrl, required this.isRead});

  final String? imageUrl;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final size = 52.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isRead
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withValues(alpha: 0.18),
                  AppColors.accentHoverColor.withValues(alpha: 0.10),
                ],
              ),
        color: isRead
            ? AppColors.primaryColor.withValues(alpha: 0.10)
            : null,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CustomCachedNetworkImage(
                isProjectDetails: true,
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Center(
                child: SvgPicture.asset(
                  Assets.images.svg.notification,
                  width: 26.w,
                  height: 26.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
