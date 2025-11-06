import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/custom_facility_item.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/select_and_deselect_all.dart';
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

  @override
  void initState() {
    super.initState();
    facilityBookingController = FacilityBookingController.get(context);
    facilityBookingController.getAllFacilityBooking();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.facilityBooking.tr()),
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
        },
        builder: (context, state) {
          final controller = facilityBookingController;
          if (state is FacilityBookingLoadingState) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
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
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                  12.ph,
                  Text(
                    LocaleKeys.no_facilities_available.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectAvailableFacilitiesText(isDark: isDark),
              6.ph,
              ServiceDescriptionText(isDark: isDark),
              10.ph,
              SelectAndDeselectAll(
                allSelected: controller.areAllSelected,
                toggleSelectAll: controller.toggleSelectAll,
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: facilities.length,
                  itemBuilder: (context, index) {
                    final item = facilities[index];
                    final selected = controller.isItemSelected(item.id!);
                    return CustomFacilityItem(
                      selected: selected,
                      isDark: isDark,
                      item: item,
                      facilityBookingController: facilityBookingController,
                    );
                  },
                ),
              ),
              12.ph,
              Center(
                child: CustomButton(
                  isLoading: state is CreateFacilityRequestLoadingState,
                  buttonColor: AppColors.primaryColor,
                  buttonText: LocaleKeys.request_now.tr(),
                  onPressed: () async {
                    await facilityBookingController.createFacilityRequest();
                  },
                ).paddingOnly(bottom: 16.h),
              ),
            ],
          ).paddingSymmetric(horizontal: 16.w);
        },
      ),
    );
  }
}
