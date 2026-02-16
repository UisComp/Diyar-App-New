import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingCard extends StatelessWidget {
  final FacilityBookingData booking;
  final bool isDark;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(booking.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CustomCachedNetworkImage(
                      imageUrl: booking.facility?.iconUrl ?? "",
                      width: 80.w,
                      height: 80.h,
                    ),
                  ),
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.facility?.title ?? "",
                        style: AppStyle.fontSize16Bold(context).copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.ph,
                      if (booking.bookingDate != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                            6.pw,
                            Expanded(
                              child: Text(
                                AppFormatter.formatDate(
                                  DateTime.parse(
                                    booking.bookingDate!,
                                  ).toUtc().toLocal(),
                                ),
                                style: AppStyle.fontSize12Regular(
                                  context,
                                ).copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                        4.ph,
                      ],
                      Row(
                        children: [
                          Icon(
                            getStatusIcon(booking.status),
                            size: 16,
                            color: statusColor,
                          ),
                          6.pw,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              getTranslatedStatus(booking.status),
                              style: AppStyle.fontSize12Bold(
                                context,
                              ).copyWith(color: statusColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
