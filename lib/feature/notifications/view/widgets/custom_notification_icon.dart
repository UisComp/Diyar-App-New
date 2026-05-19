
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
    final bool canMarkAll = notificationController.anyUnread == true &&
        (notificationController.notifications?.data?.notifications ?? [])
            .any((e) => e.type == "specific");
    final bool isLoading = state is MakeAllNotificationLoadingState;
    return IconButton(
      tooltip: canMarkAll ? 'Mark all as read' : null,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryColor,
              ),
            )
          : Icon(
              canMarkAll ? Icons.done_all_rounded : Icons.done_rounded,
              color: canMarkAll
                  ? AppColors.primaryColor
                  : AppColors.greyColor,
            ),
      onPressed: isLoading
          ? null
          : () async {
              if (canMarkAll) {
                await notificationController.markAllAsRead();
              }
            },
    );
  }
}
