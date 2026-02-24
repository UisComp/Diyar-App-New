// import 'package:diyar_app/core/extension/sized_box.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:diyar_app/core/widgets/custom_app_bar.dart';
// import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
// import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
// import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
// import 'package:diyar_app/feature/service_providers/model/service_provider_history_response_model.dart';
// import 'package:diyar_app/feature/service_providers/view/widgets/request_card.dart';
// import 'package:diyar_app/feature/service_providers/view/widgets/request_details_dialog.dart';
// import 'package:diyar_app/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class ServiceProviderHistoryScreen extends StatefulWidget {
//   const ServiceProviderHistoryScreen({
//     super.key,
//     required this.serviceProviderController,
//   });
//   final ServiceProviderController serviceProviderController;
//   @override
//   State<ServiceProviderHistoryScreen> createState() =>
//       _ServiceProviderHistoryScreenState();
// }

// class _ServiceProviderHistoryScreenState
//     extends State<ServiceProviderHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     widget.serviceProviderController.getServiceProviderHistory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BlocProvider.value(
//       value: widget.serviceProviderController,
//       child: Scaffold(
//         appBar: CustomAppBar(
//           titleAppBar: LocaleKeys.service_provider_history.tr(),
//         ),
//         body: BlocBuilder<ServiceProviderController, ServiceProviderState>(
//           builder: (context, state) {
//             if (state is ServiceProviderHistoryLoadingState) {
//               return const Skeletonizer(
//                 enabled: true,
//                 child: LoadingSkeleton(),
//               );
//             }

//             final requests =
//                 widget
//                     .serviceProviderController
//                     .serviceProviderHistoryResponseModel
//                     .data ??
//                 [];

//             if (requests.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.history, size: 80, color: Colors.grey.shade400),
//                     16.ph,
//                     AppText(
//                       LocaleKeys.no_service_booking_history_found.tr(),
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
//                 await widget.serviceProviderController
//                     .getServiceProviderHistory();
//               },
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: requests.length,
//                 itemBuilder: (context, index) {
//                   final request = requests[index];
//                   return RequestCard(
//                     request: request,
//                     isDark: isDark,
//                     onTap: () => _showRequestDetails(context, request, isDark),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showRequestDetails(
//     BuildContext context,
//     ServiceProviderBookingModel request,
//     bool isDark,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           RequestDetailsDialog(request: request, isDark: isDark),
//     );
//   }
// }

import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_history_response_model.dart';
import 'package:diyar_app/feature/service_providers/view/widgets/request_card.dart';
import 'package:diyar_app/feature/service_providers/view/widgets/request_details_dialog.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServiceProviderHistoryScreen extends StatefulWidget {
  const ServiceProviderHistoryScreen({
    super.key,
    required this.serviceProviderController,
  });
  final ServiceProviderController serviceProviderController;

  @override
  State<ServiceProviderHistoryScreen> createState() =>
      _ServiceProviderHistoryScreenState();
}

class _ServiceProviderHistoryScreenState
    extends State<ServiceProviderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabStatuses.length, vsync: this);
    widget.serviceProviderController.getServiceProviderHistory();
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

  List<ServiceProviderBookingModel> _filteredRequests(
    List<ServiceProviderBookingModel> all,
    String? status,
  ) {
    if (status == null) return all;
    return all
        .where((r) => r.status?.toLowerCase() == status.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.serviceProviderController,
      child: Scaffold(
        appBar: CustomAppBar(
          titleAppBar: LocaleKeys.service_provider_history.tr(),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: tabStatuses.map((s) => Tab(text: _tabLabel(s))).toList(),
          ),
        ),
        body: BlocBuilder<ServiceProviderController, ServiceProviderState>(
          builder: (context, state) {
            if (state is ServiceProviderHistoryLoadingState) {
              return const Skeletonizer(
                enabled: true,
                child: LoadingSkeleton(),
              );
            }

            final allRequests =
                widget
                    .serviceProviderController
                    .serviceProviderHistoryResponseModel
                    .data ??
                [];

            return TabBarView(
              controller: _tabController,
              children: tabStatuses.map((status) {
                final requests = _filteredRequests(allRequests, status);

                if (requests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        16.ph,
                        AppText(
                          LocaleKeys.no_service_booking_history_found.tr(),
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
                    await widget.serviceProviderController
                        .getServiceProviderHistory();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return RequestCard(
                        request: request,
                        isDark: isDark,
                        onTap: () =>
                            _showRequestDetails(context, request, isDark),
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

  void _showRequestDetails(
    BuildContext context,
    ServiceProviderBookingModel request,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          RequestDetailsDialog(request: request, isDark: isDark),
    );
  }
}
