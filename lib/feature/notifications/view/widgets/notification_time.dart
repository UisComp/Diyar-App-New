
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTime extends StatelessWidget {
  const NotificationTime({
    super.key,
    required this.notification,
  });

  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppFormatter.formatDate(
        DateTime.tryParse(notification.createdAt ?? '') ??
            DateTime.now(),
      ),
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 12.sp,
      ),
    );
  }
}