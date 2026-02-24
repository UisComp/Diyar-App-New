import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_list_view_facility.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_loading_facility.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/empty_facility.dart';

import 'package:diyar_app/feature/facility_booking/view/widgets/select_available_facilities_text.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/service_description_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
              color: userModel?.data?.accessToken == null
                  ? AppColors.greyColor
                  : isDark
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
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
            return CustomLoadingFacility(isDark: isDark);
          }

          if (state is FacilityBookingFailureState) {
            return Center(
              child: AppText(
                state.errorMessage ?? "Error",
                style: TextStyle(color: AppColors.redColor),
              ),
            );
          }

          final facilities = controller.facilityBookingResponseModel.data ?? [];

          if (facilities.isEmpty) {
            return EmptyFacility(isDark: isDark);
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
                CustomListViewFacility(
                  facilities: facilities,
                  controller: controller,
                  isDark: isDark,
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
