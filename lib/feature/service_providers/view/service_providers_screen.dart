import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
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
      appBar: CustomAppBar(titleAppBar: LocaleKeys.serviceProviders.tr()),
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
                                  maxLines: 1,
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
                      buttonColor: AppColors.primaryColor,
                      buttonText: LocaleKeys.request_now.tr(),
                      onPressed: () async {
                        if (controller.selectedIds.isEmpty) {
                          AppFunctions.warningMessage(
                            context,
                            message: LocaleKeys
                                .please_select_at_least_one_service
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

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, _) {
        return Container(
          height: 75.h,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
        );
      },
    );
  }
}
