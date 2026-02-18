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