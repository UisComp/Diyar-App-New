import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/feature/notifications/view/widgets/custom_notification_icon.dart';
import 'package:diyar_app/feature/notifications/view/widgets/custom_notifications_list_view.dart';
import 'package:diyar_app/feature/notifications/view/widgets/empty_notifications.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationController notificationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationController = NotificationController.get(context)
      ..fetchAllNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          notificationController.hasMore &&
          !notificationController.isLoadingMore) {
        notificationController.fetchMoreNotifications();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationController, NotificationState>(
      builder: (context, state) {
        final bool isLoading = state is NotificationLoading;
        final notifications =
            notificationController.notifications?.data?.notifications ?? [];
        return Scaffold(
          appBar: CustomAppBar(
            titleAppBar: LocaleKeys.notifications.tr(),
            actions: [
              CustomNotificationIcon(
                state: state,
                notificationController: notificationController,
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Skeletonizer(
              enabled: isLoading && notifications.isEmpty,
              child: notifications.isEmpty && !isLoading
                  ? const EmptyNotifications()
                  : CustomNotificationsListView(
                      state: state,
                      scrollController: _scrollController,
                      notifications: notifications,
                      notificationController: notificationController,
                    ),
            ),
          ),
        );
      },
    );
  }
}
