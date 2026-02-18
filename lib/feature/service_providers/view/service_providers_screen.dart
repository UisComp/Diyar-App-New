import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
import 'package:diyar_app/feature/service_providers/view/widgets/custom_list_view_service_providers.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({super.key});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  late ServiceProviderController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = ServiceProviderController.get(context);
    controller.getServiceProviders();
  }

  @override
  void dispose() {
    controller.clearControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.serviceProviders.tr(),
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
                  RoutesName.serviceProviderHistoryScreen,
                  extra: controller,
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
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: BlocConsumer<ServiceProviderController, ServiceProviderState>(
          listener: (context, state) {
            if (state is CreateServiceProviderFailureState) {
              AppFunctions.errorMessage(
                context,
                message:
                    state.errorMessage ??
                    LocaleKeys.your_request_has_been_sent_failed.tr(),
              );
            }
            if (state is CreateServiceProviderSuccessState) {
              context.pop();
              AppFunctions.successMessage(
                context,
                message: LocaleKeys.your_request_has_been_sent_successfully
                    .tr(),
              );
            }
          },
          builder: (context, state) {
            if (state is ServiceProviderLoadingState) {
              return const Skeletonizer(
                enabled: true,
                child: LoadingSkeleton(),
              );
            }

            final providers = controller.serviceProviderResponse.data ?? [];

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.select_required_service_providers.tr(),
                    style: AppStyle.fontSize18Bold(context).copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  8.ph,
                  Text(
                    LocaleKeys
                        .each_service_provider_requires_details_before_submission
                        .tr(),
                    style: AppStyle.fontSize16Regular(context).copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  16.ph,
                  CustomListViewServiceProviders(
                    providers: providers,
                    controller: controller,
                    isDark: isDark,
                  ),
                  16.ph,
                  Center(
                    child: CustomButton(
                      isLoading: state is CreateServiceProviderLoadingState,
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
                                      .please_select_at_least_one_service
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
                                      .please_select_date_for_all_services
                                      .tr(),
                                );
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                await controller.createServiceProvider();
                              }
                            },
                    ),
                  ),
                  16.ph,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
