import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/feature/notifications/view/widgets/empty_notifications.dart';
import 'package:diyar_app/feature/notifications/view/widgets/notification_item.dart';
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

  @override
  void initState() {
    super.initState();
    notificationController = NotificationController.get(context)
      ..fetchAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationController, NotificationState>(
      builder: (context, state) {
        final bool isLoading = state is NotificationLoading;

        final notifications =
            notificationController.notifications?.data?.notifications ?? [];

        return Scaffold(
          appBar: CustomAppBar(titleAppBar: LocaleKeys.notifications.tr()),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Skeletonizer(
              enabled: isLoading,
              child: notifications.isEmpty && !isLoading
                  ? const EmptyNotifications()
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          isLoading ? 5 : notifications.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: isLoading
                                ? Container(
                                    width: double.infinity,
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  )
                                : NotificationItem(
                                    notification: notifications[index],
                                  ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
