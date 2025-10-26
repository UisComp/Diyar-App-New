import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/select_and_deselect_all.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/select_available_facilities_text.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/service_description_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacilityBookingScreen extends StatefulWidget {
  const FacilityBookingScreen({super.key});

  @override
  State<FacilityBookingScreen> createState() => _FacilityBookingScreenState();
}

class _FacilityBookingScreenState extends State<FacilityBookingScreen> {
  final Map<String, bool> facilities = {
    "Wi-Fi": false,
    "Swimming Pool": false,
    "Gym": false,
    "Parking": false,
    "Conference Room": false,
    "Playground": false,
    "Spa": false,
  };

  final Map<String, String> descriptions = {
    "Wi-Fi": "High-speed wireless internet access throughout the area.",
    "Swimming Pool": "Clean and temperature-controlled pool for all ages.",
    "Gym": "Fully equipped fitness center with modern machines.",
    "Parking": "Secure and spacious parking area for residents and guests.",
    "Conference Room": "Professional meeting space with AV equipment.",
    "Playground": "Safe and fun outdoor play area for children.",
    "Spa": "Relaxation zone with massage and wellness treatments.",
  };

  final Map<String, IconData> icons = {
    "Wi-Fi": Icons.wifi,
    "Swimming Pool": Icons.pool,
    "Gym": Icons.fitness_center,
    "Parking": Icons.local_parking,
    "Conference Room": Icons.meeting_room,
    "Playground": Icons.park,
    "Spa": Icons.spa,
  };

  bool get allSelected => facilities.values.every((e) => e);

  void toggleSelectAll() {
    final newValue = !allSelected;
    setState(() {
      facilities.updateAll((key, value) => newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.facilityBooking.tr()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectAvailableFacilitiesText(isDark: isDark),
          6.ph,
          ServiceDescriptionText(isDark: isDark),
          10.ph,
          SelectAndDeselectAll(
            allSelected: allSelected,
            toggleSelectAll: toggleSelectAll,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final entry = facilities.entries.elementAt(index);
                final name = entry.key;
                final selected = entry.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryColor.withOpacity(0.12)
                        : (isDark ? AppColors.darkCard : AppColors.lightCard),
                    borderRadius: BorderRadius.circular(16),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    activeColor: AppColors.primaryColor,
                    checkColor: Colors.white,
                    value: selected,
                    onChanged: (value) {
                      setState(() => facilities[name] = value ?? false);
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: selected
                              ? AppColors.primaryColor
                              : Colors.grey.withOpacity(0.3),
                          child: Icon(
                            icons[name] ?? Icons.home_repair_service,
                            color: Colors.white,
                          ),
                        ),
                        12.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.primaryColor
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                ),
                              ),
                              4.ph,
                              Text(
                                descriptions[name] ?? "",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
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
              },
            ),
          ),
          12.ph,
          CustomButton(
            buttonColor: AppColors.primaryColor,
            buttonText: LocaleKeys.request_now.tr(),
            onPressed: () async {
              final selectedFacilities = facilities.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    selectedFacilities.isNotEmpty
                        ? "Selected: ${selectedFacilities.join(', ')}"
                        : "No facilities selected",
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.greenColor,
                ),
              );
            },
          ).paddingOnly(bottom: 16.h),
        ],
      ).paddingSymmetric(horizontal: 16.w),
    );
  }
}
