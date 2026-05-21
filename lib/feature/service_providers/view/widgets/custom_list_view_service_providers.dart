import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_response.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListViewServiceProviders extends StatelessWidget {
  const CustomListViewServiceProviders({
    super.key,
    required this.providers,
    required this.controller,
    required this.isDark,
  });

  final List<ServiceProvider> providers;
  final ServiceProviderController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final item = providers[index];
          final selected = controller.selectedIds.contains(item.id);

          final descController = controller.getDescController(item.id!);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: 6.sp),
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryColor.withOpacity(0.10)
                  : (isDark ? AppColors.darkCard : AppColors.lightCard),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.3),
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(.3),
                    blurRadius: 8.sp,
                    spreadRadius: 1.sp,
                  ),
              ],
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: selected,
                  onChanged: (value) {
                    controller.toggleService(item.id!);
                  },
                  activeColor: AppColors.primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: AppText(
                    item.jobTitle ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: selected
                          ? AppColors.primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: AppText(
                    providers[index].description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomCachedNetworkImage(
                      imageUrl: item.iconUrl ?? "",
                      width: 70.w,
                      height: 70.h,
                    ),
                  ),
                ),
                if (selected) ...[
                  8.ph,
                  CustomTextFormField(
                    controller: descController,
                    hintText: LocaleKeys.describe_your_requirements.tr(),
                    // autovalidateMode:
                    //     AutovalidateMode.onUserInteraction,
                    // validator: (v) {
                    //   if (v == null || v.isEmpty) {
                    //     return LocaleKeys.description_is_required
                    //         .tr();
                    //   }
                    //   return null;
                    // },
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
                          controller.setServiceDate(item.id!, fullDateTime);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
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
                            size: 20,
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
                  10.ph,
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
