
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:flutter/material.dart';

class CustomNotificationIcon extends StatelessWidget {
  const CustomNotificationIcon({
    super.key,
    required this.notificationController,
    required this.state,
  });

  final NotificationController notificationController;
  final NotificationState state;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        (notificationController.anyUnread == true &&
                (notificationController.notifications?.data?.notifications ??
                        [])
                    .any((e) => e.type == "specific"))
            ? Icons.notifications_active
            : Icons.notifications,
        color:
            (notificationController.anyUnread == true &&
                (notificationController.notifications?.data?.notifications ??
                        [])
                    .any((e) => e.type == "specific"))
            ? AppColors.redColor
            : null,
      ),
      onPressed: state is MakeAllNotificationLoadingState
          ? null
          : () async {
              if (notificationController.anyUnread &&
                  (notificationController.notifications?.data?.notifications
                          ?.any((e) => e.type == "specific") ??
                      false)) {
                await notificationController.markAllAsRead();
              }
            },
    );
  }
}
