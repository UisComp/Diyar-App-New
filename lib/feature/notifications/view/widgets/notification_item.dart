
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItem extends StatelessWidget {
  final NotificationData notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isRead == true
            ? AppColors.whiteColor
            : AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isRead == true
              ? Colors.grey.shade200
              : AppColors.primaryColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isRead == true
                ? Icons.notifications_none
                : Icons.notifications_active,
            color: isRead == true
                ? AppColors.primaryColor
                : AppColors.primaryColor,
            size: 26.sp,
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
                SizedBox(height: 6.h),
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
        ],
      ),
    );
  }
}
