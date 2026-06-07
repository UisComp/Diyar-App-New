import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:diyar_app/feature/notifications/view/widgets/notification_item.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// Notifications list grouped into day sections (Today / Yesterday / date),
/// each item showing the time only since its day lives in the section header.
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
    final rows = _buildRows(context);
    final hasLoader = notificationController.hasMore;

    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: rows.length + (hasLoader ? 1 : 0),
      itemBuilder: (_, index) {
        if (index >= rows.length) {
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

        final row = rows[index];
        if (row.header != null) {
          return _GroupHeader(label: row.header!, isFirst: index == 0);
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: NotificationItem(
            isLoading: state is NotificationLoading,
            notificationController: notificationController,
            notification: row.notification!,
          ),
        );
      },
    );
  }

  /// Flattens the (date-sorted) notifications into header + item rows.
  List<_Row> _buildRows(BuildContext context) {
    final rows = <_Row>[];
    String? currentBucket;
    for (final n in notifications) {
      final date =
          DateTime.tryParse(n.createdAt ?? '')?.toUtc().toLocal() ??
          DateTime.now();
      final day = DateTime(date.year, date.month, date.day);
      final bucket = day.toIso8601String();
      if (bucket != currentBucket) {
        currentBucket = bucket;
        rows.add(_Row.header(_groupLabel(day)));
      }
      rows.add(_Row.item(n));
    }
    return rows;
  }

  String _groupLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (day == today) return LocaleKeys.today.tr();
    if (day == yesterday) return LocaleKeys.yesterday.tr();
    return AppFormatter.formatDayLabel(day);
  }
}

/// A single rendered row: either a [header] label or a [notification] item.
class _Row {
  const _Row.header(this.header) : notification = null;
  const _Row.item(this.notification) : header = null;

  final String? header;
  final NotificationData? notification;
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.isFirst});

  final String label;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : 8.h, bottom: 12.h),
      child: Row(
        children: [
          AppText(
            label,
            style: AppStyle.fontSize14Bold(context).copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.descContainerColor,
              letterSpacing: 0.3,
            ),
          ),
          12.0.horizontalSpace,
          Expanded(
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.primaryColor.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
