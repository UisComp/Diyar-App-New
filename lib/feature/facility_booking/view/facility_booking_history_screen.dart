import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/booking_card.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/booking_details_dialog.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FacilityBookingHistoryScreen extends StatefulWidget {
  const FacilityBookingHistoryScreen({
    super.key,
    required this.facilityBookingController,
  });
  final FacilityBookingController facilityBookingController;

  @override
  State<FacilityBookingHistoryScreen> createState() =>
      _FacilityBookingHistoryScreenState();
}

class _FacilityBookingHistoryScreenState
    extends State<FacilityBookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.facilityBookingController.getFacilityBookingHistory();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocProvider<FacilityBookingController>.value(
      value: widget.facilityBookingController,
      child: Scaffold(
        appBar: CustomAppBar(
          titleAppBar: LocaleKeys.facility_booking_history.tr(),
        ),
        body: BlocBuilder<FacilityBookingController, FacilityBookingState>(
          builder: (context, state) {
            if (state is FacilityBookingHistoryLoadingState) {
              return const Skeletonizer(
                enabled: true,
                child: LoadingSkeleton(),
              );
            }

            final bookings =
                widget
                    .facilityBookingController
                    .facilityBookingHistoryResponseModel
                    .data ??
                [];

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80.sp, color: Colors.grey.shade400),
                    16.ph,
                    Text(
                      LocaleKeys.no_booking_history.tr(),
                      style: AppStyle.fontSize18Bold(
                        context,
                      ).copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await widget.facilityBookingController
                    .getFacilityBookingHistory();
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.sp),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return BookingCard(
                    booking: booking,
                    isDark: isDark,
                    onTap: () => _showBookingDetails(context, booking, isDark),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBookingDetails(
    BuildContext context,
    FacilityBookingData booking,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          BookingDetailsDialog(booking: booking, isDark: isDark),
    );
  }
}