import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown above a list whose every item has closed its bookings, so the
/// resident reads one explanation instead of scanning a page of dead rows.
class BookingsClosedBanner extends StatelessWidget {
  const BookingsClosedBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.greyColor),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              message,
              style: AppStyle.fontSize14Regular(
                context,
              ).copyWith(color: AppColors.greyColor),
            ),
          ),
        ],
      ),
    );
  }
}
