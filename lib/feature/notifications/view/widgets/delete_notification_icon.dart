import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteNotificationIcon extends StatelessWidget {
  const DeleteNotificationIcon({
    super.key,
    required this.notification,
    required this.notificationController,
  });

  final NotificationData notification;
  final NotificationController notificationController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (notification.id != null) {
          await notificationController.deleteNotification(notification.id!);
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
    );
  }
}
