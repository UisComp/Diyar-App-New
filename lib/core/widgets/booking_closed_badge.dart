import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The "Not taking bookings" chip shown on a facility or service provider that
/// is listed but closed.
///
/// It sits on its own line under the item's details and hugs its text, so the
/// title and description keep the full width of the card.
class BookingClosedBadge extends StatelessWidget {
  const BookingClosedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 12.sp,
            color: AppColors.greyColor,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: AppText(
              LocaleKeys.not_taking_bookings.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
