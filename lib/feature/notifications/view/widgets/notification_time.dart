import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTime extends StatelessWidget {
  const NotificationTime({super.key, required this.notification});

  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(notification.createdAt ?? '')?.toUtc().toLocal() ??
        DateTime.now().toUtc().toLocal();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 13.sp,
          color: Colors.grey.shade500,
        ),
        4.0.pw,
        AppText(
          AppFormatter.formatTimeOnly(date),
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
        ),
      ],
    );
  }
}
