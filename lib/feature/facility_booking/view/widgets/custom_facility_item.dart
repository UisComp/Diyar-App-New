import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/booking_closed_badge.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFacilityItem extends StatelessWidget {
  const CustomFacilityItem({
    super.key,
    required this.selected,
    required this.isDark,
    required this.item,
    required this.facilityBookingController,
  });

  final bool selected;
  final bool isDark;
  final Facility item;
  final FacilityBookingController facilityBookingController;

  @override
  Widget build(BuildContext context) {
    // Closed facilities stay in the list with a badge and a disabled
    // checkbox, so the resident doesn't assume the amenity is gone.
    final bookable = item.canBook;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primaryColor.withOpacity(0.12)
            : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: selected
              ? AppColors.primaryColor
              : AppColors.greyColor.withOpacity(bookable ? 0.3 : 0.5),
          width: 1.2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: CheckboxListTile(
        value: selected,
        // A null callback disables the checkbox; the tap handler in the list
        // explains why.
        onChanged: bookable
            ? (_) => facilityBookingController.toggleItem(item.id!)
            : null,
        activeColor: AppColors.primaryColor,
        checkColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: bookable ? 1 : 0.55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CustomCachedNetworkImage(
                  isProjectDetails: false,
                  width: 70.w,
                  height: 70.h,
                  imageUrl: item.icon?.url ?? '',
                ),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  if ((item.description ?? '').isNotEmpty) ...[
                    4.ph,
                    AppText(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (item.createdAt != null) ...[
                    4.ph,
                    AppText(
                      DateFormat(
                        'yyyy-MM-dd HH:mm',
                      ).format(DateTime.parse(item.createdAt!)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  // Its own line, so the title and description keep the full
                  // width of the card.
                  if (!bookable) ...[6.ph, const BookingClosedBadge()],
                ],
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
