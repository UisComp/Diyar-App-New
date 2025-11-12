import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingNotifications();
    }
    final isRead = notification.isRead;
    return InkWell(
      onTap: () async {
        if (isRead == false && notification.type != 'all') {
          await notificationController.markAsRead(notification.id!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isRead == true || notification.type == 'all'
              ? AppColors.whiteColor
              : AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isRead == true || notification.type == 'all'
                ? Colors.grey.shade200
                : AppColors.primaryColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
              isProjectDetails: true,
              imageUrl: notification.imageUrl ?? '',
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? '',
                    style: AppStyle.fontSize16Regular(context).copyWith(
                      color: AppColors.black87,
                      fontWeight: isRead == true
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  4.ph,
                  Text(
                    notification.description ?? '',
                    style: AppStyle.fontSize14RegularNewsReader(
                      context,
                    ).copyWith(color: Colors.grey.shade700),
                  ),
                  6.ph,
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(
                      DateTime.tryParse(notification.createdAt ?? '') ??
                          DateTime.now(),
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (notification.type != 'all')
              InkWell(
                onTap: () async {
                  if (notification.id != null) {
                    await notificationController.deleteNotification(
                      notification.id!,
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 24.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingNotifications extends StatelessWidget {
  const LoadingNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 50.w, height: 50.h, color: Colors.grey[400]),
          10.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: Colors.grey[400],
                ),
                4.ph,
                Container(
                  width: double.infinity,
                  height: 14.h,
                  color: Colors.grey[400],
                ),
                6.ph,
                Container(width: 120.w, height: 12.h, color: Colors.grey[400]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              width: 24.sp,
              height: 24.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
