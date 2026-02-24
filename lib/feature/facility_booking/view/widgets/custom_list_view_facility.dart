import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_facility_item.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
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
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.getSelectedDate(item.id!) ??
                            DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final DateTime fullDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          controller.setFacilityDate(item.id!, fullDateTime);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 12.sp,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                          12.pw,
                          Expanded(
                            child: AppText(
                              controller.getSelectedDate(item.id!) != null
                                  ? AppFormatter.formatDate(
                                      controller.getSelectedDate(item.id!)!,
                                    )
                                  : LocaleKeys.select_booking_date.tr(),
                              style: AppStyle.fontSize14Regular(context)
                                  .copyWith(
                                    color:
                                        controller.getSelectedDate(item.id!) !=
                                            null
                                        ? (isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary)
                                        : AppColors.greyColor,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppColors.greyColor,
                          ),
                        ],
                      ),
                    ),
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
