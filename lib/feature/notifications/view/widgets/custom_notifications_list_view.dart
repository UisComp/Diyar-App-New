import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:diyar_app/feature/notifications/view/widgets/notification_item.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomNotificationsListView extends StatelessWidget {
  const CustomNotificationsListView({
    super.key,
    required ScrollController scrollController,
    required this.notifications,
    required this.notificationController,
    required this.state,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<NotificationData> notifications;
  final NotificationController notificationController;
  final NotificationState state;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      separatorBuilder: (context, index) => 10.ph,
      itemCount:
          notifications.length + (notificationController.hasMore ? 1 : 0),
      itemBuilder: (_, index) {
        if (index < notifications.length) {
          return NotificationItem(
            isLoading: state is NotificationLoading,
            notificationController: notificationController,
            notification: notifications[index],
          );
        } else {
          return Lottie.asset(
            width: 100.w,
            height: 100.h,
            Assets.images.loading,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(['**'], value: AppColors.primaryColor),
              ],
            ),
            repeat: true,
          );
        }
      },
    );
  }
}
