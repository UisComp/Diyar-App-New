import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_facility_item.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/date_time_picker_tile.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListViewFacility extends StatelessWidget {
  const CustomListViewFacility({
    super.key,
    required this.facilities,
    required this.controller,
    required this.isDark,
  });

  final List<Facility> facilities;
  final FacilityBookingController controller;
  final bool isDark;

  Future<DateTime?> _pickDateTime(
    BuildContext context,
    DateTime? initial,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return null;

    if (!context.mounted) return null;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay.fromDateTime(initial)
          : TimeOfDay.now(),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          final item = facilities[index];
          final selected = controller.isItemSelected(item.id!);
          final notesController = controller.getNotesController(item.id!);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: 6.sp),
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryColor.withOpacity(0.10)
                  : (isDark ? AppColors.darkCard : AppColors.lightCard),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: selected
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.3),
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(.3),
                    blurRadius: 8.r,
                    spreadRadius: 1.r,
                  ),
              ],
            ),
            child: Column(
              children: [
                CustomFacilityItem(
                  selected: selected,
                  isDark: isDark,
                  item: item,
                  facilityBookingController: controller,
                ),
                if (selected) ...[
                  12.ph,
                  CustomTextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: notesController,
                    hintText: LocaleKeys.notes.tr(),
                    maxLines: 2,
                  ),
                  8.ph,
                  // ── Start Date & Time ─────────────────────────────────
                  DateTimePickerTile(
                    isDark: isDark,
                    label: LocaleKeys.select_booking_date.tr(),
                    prefixLabel: '▶',
                    prefixColor: AppColors.primaryColor,
                    icon: Icons.play_circle_outline,
                    iconColor: AppColors.primaryColor,
                    dateTime: controller.getSelectedStartDate(item.id!),
                    onTap: () async {
                      final dt = await _pickDateTime(
                        context,
                        controller.getSelectedStartDate(item.id!),
                      );
                      if (dt != null) {
                        controller.setFacilityStartDate(item.id!, dt);
                      }
                    },
                  ),
                  8.ph,

                  // ── End Date & Time ───────────────────────────────────
                  DateTimePickerTile(
                    isDark: isDark,
                    label: LocaleKeys.select_booking_date.tr(),
                    prefixLabel: '■',
                    prefixColor: AppColors.redAccentColor,
                    icon: Icons.stop_circle_outlined,
                    iconColor: Colors.redAccent,
                    dateTime: controller.getSelectedEndDate(item.id!),
                    onTap: () async {
                      final DateTime initialEnd =
                          controller.getSelectedEndDate(item.id!) ??
                          (controller.getSelectedStartDate(item.id!) ??
                                  DateTime.now())
                              .add(const Duration(hours: 1));
                      final dt = await _pickDateTime(context, initialEnd);
                      if (dt != null) {
                        final startDate = controller.getSelectedStartDate(
                          item.id!,
                        );
                        if (startDate != null && !dt.isAfter(startDate)) {
                          if (context.mounted) {
                            AppFunctions.errorMessage(
                              context,
                              message: LocaleKeys
                                  .end_date_must_be_after_start_date
                                  .tr(),
                            );
                          }
                          return;
                        }
                        controller.setFacilityEndDate(item.id!, dt);
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

