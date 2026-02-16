import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
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
    extends State<ServiceProviderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.serviceProviderController.getServiceProviderHistory();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.serviceProviderController,
      child: Scaffold(
        appBar: CustomAppBar(
          titleAppBar: LocaleKeys.service_provider_history.tr(),
        ),
        body: BlocBuilder<ServiceProviderController, ServiceProviderState>(
          builder: (context, state) {
            if (state is ServiceProviderHistoryLoadingState) {
              return const Skeletonizer(
                enabled: true,
                child: LoadingSkeleton(),
              );
            }

            final requests =
                widget
                    .serviceProviderController
                    .serviceProviderHistoryResponseModel
                    .data ??
                [];

            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey.shade400),
                    16.ph,
                    Text(
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
                    onTap: () => _showRequestDetails(context, request, isDark),
                  );
                },
              ),
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







// class _RequestCard extends StatelessWidget {
//   final ServiceProviderBookingModel request;
//   final bool isDark;
//   final VoidCallback onTap;

//   const _RequestCard({
//     required this.request,
//     required this.isDark,
//     required this.onTap,
//   });

//   Color _getStatusColor(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'completed':
//         return Icons.check_circle;
//       case 'pending':
//         return Icons.access_time;
//       case 'cancelled':
//         return Icons.cancel;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor(request.status);
//     final serviceProvider = request.serviceProvider;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.darkCard : AppColors.lightCard,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Service Provider Icon
//                 Container(
//                   width: 80.w,
//                   height: 80.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: statusColor.withOpacity(0.3),
//                       width: 2,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: CustomCachedNetworkImage(
//                       imageUrl: serviceProvider?.iconUrl ?? "",
//                       width: 80.w,
//                       height: 80.h,
//                     ),
//                   ),
//                 ),
//                 16.pw,
//                 // Service Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         serviceProvider?.jobTitle ?? "N/A",
//                         style: AppStyle.fontSize16Bold(context).copyWith(
//                           color: isDark
//                               ? AppColors.darkTextPrimary
//                               : AppColors.lightTextPrimary,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       4.ph,
//                       if (request.bookingDate != null) ...[
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.calendar_today,
//                               size: 14,
//                               color: Colors.grey.shade600,
//                             ),
//                             6.pw,
//                             Expanded(
//                               child: Text(
//                                 AppFormatter.formatDate(
//                                   DateTime.parse(request.bookingDate!),
//                                 ),
//                                 style: AppStyle.fontSize12Regular(
//                                   context,
//                                 ).copyWith(color: Colors.grey.shade600),
//                               ),
//                             ),
//                           ],
//                         ),
//                         4.ph,
//                       ],
//                       Row(
//                         children: [
//                           Icon(
//                             _getStatusIcon(request.status),
//                             size: 16,
//                             color: statusColor,
//                           ),
//                           6.pw,
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               getTranslatedStatus(request.status),
//                               style: AppStyle.fontSize12Bold(
//                                 context,
//                               ).copyWith(color: statusColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Colors.grey.shade400,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RequestDetailsDialog extends StatelessWidget {
//   final ServiceProviderBookingModel request;
//   final bool isDark;

//   const RequestDetailsDialog({
//     super.key,
//     required this.request,
//     required this.isDark,
//   });

//   Color _getStatusColor(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor(request.status);
//     final serviceProvider = request.serviceProvider;

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.7,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkCard : AppColors.lightCard,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header with image
//             Container(
//               height: 150.h,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 gradient: LinearGradient(
//                   colors: [
//                     statusColor.withOpacity(0.8),
//                     statusColor.withOpacity(0.4),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: CustomCachedNetworkImage(
//                         imageUrl: serviceProvider?.iconUrl ?? "",
//                         width: 100.w,
//                         height: 100.h,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Content
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     Center(
//                       child: Text(
//                         serviceProvider?.jobTitle ?? "N/A",
//                         style: AppStyle.fontSize20Bold(context).copyWith(
//                           color: isDark
//                               ? AppColors.darkTextPrimary
//                               : AppColors.lightTextPrimary,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     8.ph,
//                     Center(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: statusColor.withOpacity(0.5),
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.circle, size: 10.sp, color: statusColor),
//                             8.pw,
//                             Text(
//                               getTranslatedStatus(request.status),
//                               style: AppStyle.fontSize14Bold(
//                                 context,
//                               ).copyWith(color: statusColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     20.ph,
//                     if (serviceProvider?.description != null) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.description,
//                         label: LocaleKeys.description.tr(),
//                         value: serviceProvider!.description!,
//                         isDark: isDark,
//                       ),
//                     ],
//                     if (request.bookingDate != null) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.calendar_today,
//                         label: LocaleKeys.booking_date.tr(),
//                         value: AppFormatter.formatDate(
//                           DateTime.parse(request.bookingDate!).toUtc(),
//                         ),
//                         isDark: isDark,
//                       ),
//                     ],
//                     if (request.notes != null) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.note,
//                         label: LocaleKeys.notes.tr(),
//                         value: request.notes!,
//                         isDark: isDark,
//                       ),
//                     ],
//                     if (request.user != null) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.person,
//                         label: LocaleKeys.user_name.tr(),
//                         value: request.user!.name ?? "",
//                         isDark: isDark,
//                       ),
//                     ],
//                     if (request.createdAt != null) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.access_time,
//                         label: LocaleKeys.created_at.tr(),
//                         value: AppFormatter.formatDate(
//                           DateTime.parse(request.createdAt!),
//                         ),
//                         isDark: isDark,
//                       ),
//                     ],
//                     if (request.updatedAt != null &&
//                         request.updatedAt != request.createdAt) ...[
//                       12.ph,
//                       DetailRow(
//                         icon: Icons.update,
//                         label: LocaleKeys.updated_at.tr(),
//                         value: AppFormatter.formatDate(
//                           DateTime.parse(request.updatedAt!).toUtc(),
//                         ),
//                         isDark: isDark,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
