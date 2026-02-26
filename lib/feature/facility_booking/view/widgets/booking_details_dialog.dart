import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/detail_row.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsDialog extends StatelessWidget {
  final FacilityBookingData booking;
  final bool isDark;

  const BookingDetailsDialog({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(booking.status);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.8),
                    statusColor.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomCachedNetworkImage(
                        imageUrl: booking.facility?.iconUrl ?? "",
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AppText(
                        booking.facility?.title ?? "",
                        style: AppStyle.fontSize20Bold(context).copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    8.ph,
                    Center(
                      child: Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 16.sp,
                          vertical: 8.sp,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 10.sp, color: statusColor),
                            8.pw,
                            AppText(
                              getTranslatedStatus(
                                booking.status?.toUpperCase() ?? "",
                              ),
                              style: AppStyle.fontSize14Bold(
                                context,
                              ).copyWith(color: statusColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.ph,
                    // Description
                    if (booking.facility?.description != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.description,
                        label: LocaleKeys.description.tr(),
                        value: booking.facility!.description!,
                        isDark: isDark,
                      ),
                    ],

                    // Booking Start
                    if (booking.bookingStart != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.play_circle_outline,
                        label: LocaleKeys.start_date.tr(),
                        value: AppFormatter.formatDateWithTime(
                          DateTime.parse(booking.bookingStart!).toLocal(),
                        ),
                        isDark: isDark,
                      ),
                    ],
                    if (booking.bookingEnd != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.stop_circle_outlined,
                        label: LocaleKeys.end_date.tr(),
                        value: AppFormatter.formatDateWithTime(
                          DateTime.parse(booking.bookingEnd!).toLocal(),
                        ),
                        isDark: isDark,
                      ),
                    ],

                    if (booking.notes != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.note,
                        label: LocaleKeys.notes.tr(),
                        value: booking.notes!,
                        isDark: isDark,
                      ),
                    ],

                    if (booking.user != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.person,
                        label: LocaleKeys.user_name.tr(),
                        value: booking.user!.name ?? "",
                        isDark: isDark,
                      ),
                    ],
                    if (booking.createdAt != null) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.access_time,
                        label: LocaleKeys.created_at.tr(),
                        value: AppFormatter.formatDate(
                          DateTime.parse(booking.createdAt!).toUtc().toLocal(),
                        ),
                        isDark: isDark,
                      ),
                    ],
                    if (booking.updatedAt != null &&
                        booking.updatedAt != booking.createdAt) ...[
                      12.ph,
                      DetailRow(
                        icon: Icons.update,
                        label: LocaleKeys.updated_at.tr(),
                        value: AppFormatter.formatDate(
                          DateTime.parse(booking.updatedAt!),
                        ),
                        isDark: isDark,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
