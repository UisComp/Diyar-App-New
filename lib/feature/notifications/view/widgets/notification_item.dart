// import 'package:diyar_app/core/constants/app_constants.dart';
// import 'package:diyar_app/core/extension/sized_box.dart';
// import 'package:diyar_app/core/routes/routes_name.dart';
// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:diyar_app/core/widgets/app_text.dart';
// import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
// import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
// import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
// import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
// import 'package:diyar_app/feature/notifications/view/widgets/delete_notification_icon.dart';
// import 'package:diyar_app/feature/notifications/view/widgets/loading_notifications.dart';
// import 'package:diyar_app/feature/notifications/view/widgets/notification_time.dart';
// import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
// import 'package:diyar_app/gen/assets.gen.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';

// class NotificationItem extends StatelessWidget {
//   final NotificationData notification;
//   final NotificationController notificationController;
//   final bool isLoading;

//   const NotificationItem({
//     super.key,
//     required this.notification,
//     required this.notificationController,
//     this.isLoading = false,
//   });
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const LoadingNotifications();
//     }
//     final isRead = notification.isRead;
//     return InkWell(
//       onTap: () async {
//         if (isRead == false &&
//             notification.type != 'all' &&
//             notification.entityType == null) {
//           await notificationController.markAsRead(notification.id!);
//         }

//         if (notification.entityType == "1") {
//           final controller = FacilityBookingController();
//           await controller.getFacilityBookingHistory();
//           context.push(
//             RoutesName.facilityBookingHistoryScreen,
//             extra: controller,
//           );
//         } else if (notification.entityType == "2") {
//           final controller = ServiceProviderController();
//           await controller.getServiceProviderHistory();
//           context.push(
//             RoutesName.serviceProviderHistoryScreen,
//             extra: controller,
//           );
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.all(12.sp),
//         decoration: BoxDecoration(
//           color: isRead == true || notification.type == 'all'
//               ? AppColors.whiteColor
//               : AppColors.primaryColor.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(
//             color: isRead == true || notification.type == 'all'
//                 ? Colors.grey.shade200
//                 : AppColors.primaryColor.withOpacity(0.5),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             (notification.imageUrl != null)
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(8.r),
//                     child: CustomCachedNetworkImage(
//                       isProjectDetails: true,
//                       imageUrl: notification.imageUrl ?? '',
//                       width: 80.w,
//                       height: 80.h,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : SvgPicture.asset(
//                     Assets.images.svg.notification,
//                     width: 40.w,
//                     height: 40.h,
//                     color: AppColors.primaryColor,
//                   ),
//             10.pw,
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     context.locale == Locale(AppConstants.arLanguage)
//                         ? notification.titleAr ?? ''
//                         : notification.title ?? '',
//                     style: AppStyle.fontSize16Regular(context).copyWith(
//                       color: AppColors.black87,
//                       fontWeight: isRead == true
//                           ? FontWeight.w500
//                           : FontWeight.bold,
//                     ),
//                   ),
//                   4.ph,
//                   AppText(
//                     context.locale == Locale(AppConstants.arLanguage)
//                         ? notification.descriptionAr ?? ''
//                         : notification.description ?? '',
//                     style: AppStyle.fontSize14RegularNewsReader(
//                       context,
//                     ).copyWith(color: Colors.grey.shade700),
//                   ),
//                   6.ph,
//                   NotificationTime(notification: notification),
//                 ],
//               ),
//             ),
//             if (notification.type != 'all')
//               DeleteNotificationIcon(
//                 notification: notification,
//                 notificationController: notificationController,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:diyar_app/core/constants/app_constants.dart';
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
    final isRead = notification.isRead;
    return InkWell(
      onTap: () async {
        if (isRead == false &&
            notification.type != 'all' &&
            notification.entityType == null) {
          await notificationController.markAsRead(notification.id!);
        }

        if (notification.entityType == "1") {
          final controller = FacilityBookingController();
          await controller.getFacilityBookingHistory();
          notificationController.markAsRead(notification.id!);
          context.push(
            RoutesName.facilityBookingHistoryScreen,
            extra: controller,
          );
        } else if (notification.entityType == "2") {
          final controller = ServiceProviderController();
          await controller.getServiceProviderHistory();
          notificationController.markAsRead(notification.id!);
          context.push(
            RoutesName.serviceProviderHistoryScreen,
            extra: controller,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (notification.imageUrl != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomCachedNetworkImage(
                      isProjectDetails: true,
                      imageUrl: notification.imageUrl ?? '',
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgPicture.asset(
                    Assets.images.svg.notification,
                    width: 40.w,
                    height: 40.h,
                    color: AppColors.primaryColor,
                  ),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    _getTitle(context),
                    style: AppStyle.fontSize16Regular(context).copyWith(
                      color: AppColors.black87,
                      fontWeight: isRead == true
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  4.ph,
                  AppText(
                    _getDescription(context),
                    style: AppStyle.fontSize14RegularNewsReader(
                      context,
                    ).copyWith(color: Colors.grey.shade700),
                  ),
                  6.ph,
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
    );
  }
}
