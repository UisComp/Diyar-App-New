// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class NotificationScreen extends StatefulWidget {
// //   const NotificationScreen({super.key});

// //   @override
// //   State<NotificationScreen> createState() => _NotificationScreenState();
// // }

// // class _NotificationScreenState extends State<NotificationScreen> {
// //   int? deletingNotificationId;
// //   final ScrollController _scrollController = ScrollController();
// //   bool _isLoadingMore = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // context.read<NotificationController>().fetchAllNotifications();
// //     _scrollController.addListener(_onScroll);
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.removeListener(_onScroll);
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   void _onScroll() {
// //     if (_isLoadingMore) return;

// //     final maxScroll = _scrollController.position.maxScrollExtent;
// //     final currentScroll = _scrollController.position.pixels;
// //     final threshold = maxScroll * 0.9;

// //   //   final controller = context.read<NotificationController>();

// //   //   if (currentScroll > threshold && controller.hasMore && controller.state is! NotificationLoading) {
// //   //     setState(() {
// //   //       _isLoadingMore = true;
// //   //     });

// //   //     controller.fetchAllNotifications(
// //   //       page: controller.currentPage + 1,
// //   //     ).then((_) {
// //   //       setState(() {
// //   //         _isLoadingMore = false;
// //   //       });
// //   //     });
// //   //   }
// //   // }

// //   // Widget _buildPaginationLoader(NotificationController controller) {
// //   //   return _isLoadingMore
// //   //       ? Padding(
// //   //           padding: EdgeInsets.symmetric(vertical: 16.0),
// //   //           child: Center(child: CircularProgressIndicator()),
// //   //         )
// //   //       : SizedBox.shrink();
// //   // }

// //    buildAppBar(NotificationController controller) {
// //     final notifications = controller.notifications;
// //     final notificationList = notifications?.data;
// //     bool canMarkAllAsRead = notificationList != null &&
// //         notificationList.isNotEmpty &&
// //         notificationList.any((notif) => notif.isRead == 0 && notif.type == 'personal');

// //     return AppBar(
// //       backgroundColor: AppColor.White,
// //       centerTitle: true,
// //       title: Text(
// //         appLanguage(context).notification_title,
// //         style: TextStyle(color: AppColor.Very_Dark),
// //       ),
// //       leading: IconButton(
// //         icon: Icon(Icons.arrow_back, color: AppColor.Very_Dark),
// //         onPressed: () {
// //           backPage();
// //         },
// //       ),
// //       actions: [
// //         if (notificationList != null && notificationList.isNotEmpty)
// //           IconButton(
// //             onPressed: canMarkAllAsRead
// //                 ? () async {
// //                     await controller.markAllAsRead();
// //                   }
// //                 : null,
// //             icon: Icon(
// //               Icons.check_circle_outline,
// //               color: canMarkAllAsRead ? AppColor.Grey1 : AppColor.Grey3,
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocConsumer<NotificationController, NotificationState>(
// //       listener: (context, state) {
// //         if (state is DeleteNotificationSuccess) {
// //           successMessage(
// //             message: state.generalNotificationModel?.data!.message ?? 'Notification deleted successfully',
// //           );
// //         }
// //         if (state is DeleteNotificationError) {
// //           log("Failed to delete notification: ${state.error}");
// //           errorMessage(
// //             message: state.error ?? 'Failed to delete notification',
// //           );
// //         }
// //         if (state is NotificationError) {
// //           log("Failed to fetch notifications: ${state.error}");
// //           errorMessage(
// //             message: state.error ?? 'Failed to fetch notifications',
// //           );
// //         }
// //       },
// //       builder: (context, state) {
// //         final notificationController = NotificationController.get(context);
// //         final notifications = notificationController.notifications;
// //         final notificationList = notifications?.data;

// //         if (state is MakeAllNotificationLoadingState) {
// //           return Scaffold(
// //             appBar: buildAppBar(notificationController),
// //             body: const Center(child: CircularProgressIndicator()),
// //           );
// //         }

// //         return Scaffold(
// //           appBar: buildAppBar(notificationController),
// //           body: notificationList == null || notificationList.isEmpty
// //               ? Center(
// //                   child: Text(
// //                     'No Notifications',
// //                     style: TextStyle(
// //                       color: AppColor.Very_Dark,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 20.sp,
// //                     ),
// //                   ),
// //                 )
// //               : RefreshIndicator(
// //                   onRefresh: () async {
// //                     await notificationController.fetchAllNotifications(refresh: true);
// //                   },
// //                   child: ListView.separated(
// //                     addAutomaticKeepAlives: true,
// //                     physics: AlwaysScrollableScrollPhysics(),
// //                     controller: _scrollController,
// //                     padding: EdgeInsets.symmetric(vertical: 16),
// //                     itemCount: notificationList.length + 1, // +1 for loader
// //                     separatorBuilder: (context, index) => SizedBox(height: 5.h),
// //                     itemBuilder: (context, index) {
// //                       if (index < notificationList.length) {
// //                         final notification = notificationList[index];
// //                         return CustomNotificationItem(
// //                           isDeleting: deletingNotificationId == notification.id,
// //                           notification: notification,
// //                           onDelete: () async {
// //                             if (notification.id != null) {
// //                               deletingNotificationId = notification.id;
// //                               await notificationController.deleteNotification(notification.id!);
// //                               deletingNotificationId = null;
// //                             }
// //                           },
// //                         );
// //                       } else {
// //                         return _buildPaginationLoader(notificationController);
// //                       }
// //                     },
// //                   ),
// //                 ),
// //         );
// //       },
// //     );
// //   }
// // }

// import 'package:diyar_app/core/widgets/custom_app_bar.dart';
// import 'package:diyar_app/feature/notifications/view/widgets/empty_notifications.dart';
// import 'package:diyar_app/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(titleAppBar: LocaleKeys.notifications.tr()),
//       body: EmptyNotifications(),
//     );
//   }
// }


import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // 👇 Dummy notifications data
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: "Welcome to Diyar!",
      body: "We’re glad to have you. Explore properties and services today.",
      date: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: 2,
      title: "Your booking was successful",
      body: "Your villa booking #A-452 has been confirmed for next weekend.",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: 3,
      title: "Limited-time offer",
      body: "Enjoy 20% off all property listings until Friday!",
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: 4,
      title: "Maintenance Reminder",
      body: "Your scheduled maintenance for Apartment 203 is tomorrow.",
      date: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.notifications.tr()),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications available"))
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationItem(notification: notif);
              },
            ),
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime date;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.isRead,
  });
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isRead ? AppColors.whiteColor : AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isRead ? Colors.grey.shade200 : AppColors.primaryColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isRead ? Icons.notifications_none : Icons.notifications_active,
            color: isRead ? AppColors.primaryColor : AppColors.primaryColor,
            size: 26.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: AppColors.black87,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.body,
                  style: AppStyle.fontSize14RegularNewsReader(context).copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(notification.date),
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
