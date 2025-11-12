import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedDateInfo extends StatelessWidget {
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const SelectedDateInfo({
    super.key,
    required this.rangeStart,
    required this.rangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (rangeEnd == null || rangeStart == rangeEnd) {
      return Text(
        AppFormatter.unitEventDateFormatter().format(rangeStart!),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${LocaleKeys.from.tr()}: ${AppFormatter.unitEventDateFormatter().format(rangeStart!)}',
              style: AppStyle.fontSize18Bold(
                context,
              ).copyWith(fontSize: 16.sp, overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              '${LocaleKeys.to.tr()}: ${AppFormatter.unitEventDateFormatter().format(rangeEnd!)}',
              style: AppStyle.fontSize18Bold(
                context,
              ).copyWith(fontSize: 16.sp, overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ),
          ),
        ],
      );
    }
  }
}
