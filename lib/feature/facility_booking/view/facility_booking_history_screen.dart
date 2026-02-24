// import 'package:diyar_app/core/extension/sized_box.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:diyar_app/core/widgets/custom_app_bar.dart';
// import 'package:diyar_app/feature/facility_booking/controller/facility_booking_controller.dart';
// import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
// import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
// import 'package:diyar_app/feature/facility_booking/view/widgets/booking_card.dart';
// import 'package:diyar_app/feature/facility_booking/view/widgets/booking_details_dialog.dart';
// import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
// import 'package:diyar_app/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class FacilityBookingHistoryScreen extends StatefulWidget {
//   const FacilityBookingHistoryScreen({
//     super.key,
//     required this.facilityBookingController,
//   });
//   final FacilityBookingController facilityBookingController;

//   @override
//   State<FacilityBookingHistoryScreen> createState() =>
//       _FacilityBookingHistoryScreenState();
// }

// class _FacilityBookingHistoryScreenState
//     extends State<FacilityBookingHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     widget.facilityBookingController.getFacilityBookingHistory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BlocProvider<FacilityBookingController>.value(
//       value: widget.facilityBookingController,
//       child: Scaffold(
//         appBar: CustomAppBar(
//           titleAppBar: LocaleKeys.facility_booking_history.tr(),
//         ),
//         body: BlocBuilder<FacilityBookingController, FacilityBookingState>(
//           builder: (context, state) {
//             if (state is FacilityBookingHistoryLoadingState) {
//               return const Skeletonizer(
//                 enabled: true,
//                 child: LoadingSkeleton(),
//               );
//             }

//             final bookings =
//                 widget
//                     .facilityBookingController
//                     .facilityBookingHistoryResponseModel
//                     .data ??
//                 [];

//             if (bookings.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.history,
//                       size: 80.sp,
//                       color: Colors.grey.shade400,
//                     ),
//                     16.ph,
//                     AppText(
//                       LocaleKeys.no_booking_history.tr(),
//                       style: AppStyle.fontSize18Bold(
//                         context,
//                       ).copyWith(color: Colors.grey.shade600),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () async {
//                 await widget.facilityBookingController
//                     .getFacilityBookingHistory();
//               },
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16.sp),
//                 itemCount: bookings.length,
//                 itemBuilder: (context, index) {
//                   final booking = bookings[index];
//                   return BookingCard(
//                     booking: booking,
//                     isDark: isDark,
//                     onTap: () => _showBookingDetails(context, booking, isDark),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showBookingDetails(
//     BuildContext context,
//     FacilityBookingData booking,
//     bool isDark,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           BookingDetailsDialog(booking: booking, isDark: isDark),
//     );
//   }
// }

import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
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
    extends State<FacilityBookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define tab statuses — add/remove as needed to match your API values
  // static const List<String?> _tabStatuses = [
  //   'pending',
  //   'confirmed',
  //   'completed',
  //   'cancelled',
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabStatuses.length, vsync: this);
    widget.facilityBookingController.getFacilityBookingHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _tabLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return LocaleKeys.pending.tr();
      case 'confirmed':
        return LocaleKeys.confirmed.tr();
      case 'completed':
        return LocaleKeys.completed.tr();
      case 'cancelled':
        return LocaleKeys.cancelled.tr();
      default:
        return status?.toUpperCase() ?? '';
    }
  }

  List<FacilityBookingData> _filteredBookings(
    List<FacilityBookingData> all,
    String? status,
  ) {
    if (status == null) return all;
    return all
        .where((b) => b.status?.toLowerCase() == status.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<FacilityBookingController>.value(
      value: widget.facilityBookingController,
      child: Scaffold(
        appBar: CustomAppBar(
          titleAppBar: LocaleKeys.facility_booking_history.tr(),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: tabStatuses.map((s) => Tab(text: _tabLabel(s))).toList(),
          ),
        ),
        body: BlocBuilder<FacilityBookingController, FacilityBookingState>(
          builder: (context, state) {
            if (state is FacilityBookingHistoryLoadingState) {
              return const Skeletonizer(
                enabled: true,
                child: LoadingSkeleton(),
              );
            }

            final allBookings =
                widget
                    .facilityBookingController
                    .facilityBookingHistoryResponseModel
                    .data ??
                [];

            return TabBarView(
              controller: _tabController,
              children: tabStatuses.map((status) {
                final bookings = _filteredBookings(allBookings, status);

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80.sp,
                          color: Colors.grey.shade400,
                        ),
                        16.ph,
                        AppText(
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
                        onTap: () =>
                            _showBookingDetails(context, booking, isDark),
                      );
                    },
                  ),
                );
              }).toList(),
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
