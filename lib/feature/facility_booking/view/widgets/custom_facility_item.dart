import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:flutter/material.dart';
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
              : Colors.grey.withOpacity(0.3),
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
        onChanged: (_) => facilityBookingController.toggleItem(item.id!),
        activeColor: AppColors.primaryColor,
        checkColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CustomCachedNetworkImage(
                isProjectDetails: false,
                width: 70.w,
                height: 70.h,
                imageUrl: item.icon?.url ?? '',
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  4.ph,
                  Text(
                    item.description ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 13,
                    ),
                  ),
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
