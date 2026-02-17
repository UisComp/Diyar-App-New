import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_facility_item.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/select_available_facilities_text.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/service_description_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FacilityBookingScreen extends StatefulWidget {
  const FacilityBookingScreen({super.key});

  @override
  State<FacilityBookingScreen> createState() => _FacilityBookingScreenState();
}

class _FacilityBookingScreenState extends State<FacilityBookingScreen> {
  late FacilityBookingController facilityBookingController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    facilityBookingController = FacilityBookingController.get(context);
    facilityBookingController.getAllFacilityBooking();
  }

  @override
  void dispose() {
    facilityBookingController.clearControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.facilityBooking.tr(),
        actions: [
          IconButton(
            onPressed: () {
              if (userModel?.data?.accessToken == null) {
                AppFunctions.warningMessage(
                  context,
                  message: LocaleKeys.available_for_logged_in_users_only.tr(),
                );
              } else {
                context.push(
                  RoutesName.facilityBookingHistoryScreen,
                  extra: facilityBookingController,
                );
              }
            },
            icon: Icon(
              Icons.history,
              color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ],
      ),
      body: BlocConsumer<FacilityBookingController, FacilityBookingState>(
        listener: (context, state) {
          if (state is PleaseSelectYourFacilityState) {
            AppFunctions.warningMessage(
              context,
              message: LocaleKeys.you_must_select_at_least_one_facility.tr(),
            );
          }
          if (state is CreateFacilityRequestSuccessState) {
            context.pop();
            AppFunctions.successMessage(
              context,
              message: LocaleKeys.your_request_has_been_sent_successfully.tr(),
            );
          }
          if (state is CreateFacilityRequestFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  state.errorMessage ??
                  LocaleKeys.your_request_has_been_sent_failed.tr(),
            );
          }
        },
        builder: (context, state) {
          final controller = facilityBookingController;

          if (state is FacilityBookingLoadingState) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, _) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.sp),
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 16.w);
          }

          if (state is FacilityBookingFailureState) {
            return Center(
              child: Text(
                state.errorMessage ?? "Error",
                style: TextStyle(color: AppColors.redColor),
              ),
            );
          }

          final facilities = controller.facilityBookingResponseModel.data ?? [];

          if (facilities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 50.sp,
                    color: AppColors.primaryColor,
                  ),
                  12.ph,
                  Text(
                    LocaleKeys.no_facilities_available.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectAvailableFacilitiesText(isDark: isDark),
                6.ph,
                ServiceDescriptionText(isDark: isDark),
                10.ph,
                // SelectAndDeselectAll(
                //   allSelected: controller.areAllSelected,
                //   toggleSelectAll: controller.toggleSelectAll,
                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final item = facilities[index];
                      final selected = controller.isItemSelected(item.id!);
                      final notesController = controller.getNotesController(
                        item.id!,
                      );

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(vertical: 6.sp),
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryColor.withOpacity(0.10)
                              : (isDark
                                    ? AppColors.darkCard
                                    : AppColors.lightCard),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.3),
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
                                controller: notesController,
                                hintText: LocaleKeys.notes.tr(),
                                maxLines: 2,
                              ),
                              8.ph,
                              InkWell(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate:
                                            controller.getSelectedDate(
                                              item.id!,
                                            ) ??
                                            DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                      );

                                  if (pickedDate != null) {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
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
                                      controller.setFacilityDate(
                                        item.id!,
                                        fullDateTime,
                                      );
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
                                      color: Colors.grey.withOpacity(0.3),
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
                                        child: Text(
                                          controller.getSelectedDate(
                                                    item.id!,
                                                  ) !=
                                                  null
                                              ? AppFormatter.formatDate(
                                                  controller.getSelectedDate(
                                                    item.id!,
                                                  )!,
                                                )
                                              : LocaleKeys.select_booking_date
                                                    .tr(),
                                          style:
                                              AppStyle.fontSize14Regular(
                                                context,
                                              ).copyWith(
                                                color:
                                                    controller.getSelectedDate(
                                                          item.id!,
                                                        ) !=
                                                        null
                                                    ? (isDark
                                                          ? AppColors
                                                                .darkTextPrimary
                                                          : AppColors
                                                                .lightTextPrimary)
                                                    : Colors.grey,
                                              ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16.sp,
                                        color: Colors.grey,
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
                ),
                12.ph,
                Center(
                  child: CustomButton(
                    isLoading: state is CreateFacilityRequestLoadingState,
                    buttonColor: userModel?.data?.accessToken == null
                        ? AppColors.greyColor
                        : AppColors.primaryColor,
                    buttonText: LocaleKeys.request_now.tr(),
                    onPressed: userModel?.data?.accessToken == null
                        ? null
                        : () async {
                            if (userModel?.data?.accessToken == null) {
                              AppFunctions.warningMessage(
                                context,
                                message: LocaleKeys
                                    .available_for_logged_in_users_only
                                    .tr(),
                              );
                              return;
                            }

                            if (controller.selectedIds.isEmpty) {
                              AppFunctions.warningMessage(
                                context,
                                message: LocaleKeys
                                    .you_must_select_at_least_one_facility
                                    .tr(),
                              );
                              return;
                            }
                            bool allHaveDates = true;
                            for (var id in controller.selectedIds) {
                              if (controller.getSelectedDate(id) == null) {
                                allHaveDates = false;
                                break;
                              }
                            }

                            if (!allHaveDates) {
                              AppFunctions.warningMessage(
                                context,
                                message: LocaleKeys
                                    .please_select_date_for_all_facilities
                                    .tr(),
                              );
                              return;
                            }

                            await controller.createFacilityRequest();
                          },
                  ).paddingOnly(bottom: 16.h),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.w),
          );
        },
      ),
    );
  }
}
