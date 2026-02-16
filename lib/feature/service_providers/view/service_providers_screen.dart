import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/facility_booking/view/widgets/loading_skeleton.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_controller.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
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
              color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

                  Expanded(
                    child: ListView.builder(
                      itemCount: providers.length,
                      itemBuilder: (context, index) {
                        final item = providers[index];
                        final selected = controller.selectedIds.contains(
                          item.id,
                        );

                        final descController = controller.getDescController(
                          item.id!,
                        );

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryColor.withOpacity(0.10)
                                : (isDark
                                      ? AppColors.darkCard
                                      : AppColors.lightCard),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryColor
                                  : Colors.grey.withOpacity(0.3),
                            ),
                            boxShadow: [
                              if (selected)
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
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
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text(
                                  item.jobTitle ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: selected
                                        ? AppColors.primaryColor
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                subtitle: Text(
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
                                  hintText: LocaleKeys
                                      .describe_your_requirements
                                      .tr(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return LocaleKeys.description_is_required
                                          .tr();
                                    }
                                    return null;
                                  },
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
                                        controller.setServiceDate(
                                          item.id!,
                                          fullDateTime,
                                        );
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
                                        color: Colors.grey.withOpacity(0.3),
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
                                                : LocaleKeys.select_date_range
                                                      .tr(),
                                            style:
                                                AppStyle.fontSize14Regular(
                                                  context,
                                                ).copyWith(
                                                  color:
                                                      controller
                                                              .getSelectedDate(
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
                                          size: 16,
                                          color: Colors.grey,
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
