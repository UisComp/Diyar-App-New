import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_switch_list_tile.dart';
import 'package:diyar_app/feature/settings/view/widgets/header_bio_metric_section.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BioMetricScreen extends StatefulWidget {
  const BioMetricScreen({super.key});

  @override
  State<BioMetricScreen> createState() => _BioMetricScreenState();
}

class _BioMetricScreenState extends State<BioMetricScreen> {
  late SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    settingsController = SettingsController.get(context);
    settingsController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.biometric.tr().toUpperCase(),
      ),
      body: BlocConsumer<SettingsController, SettingsState>(
        listener: (context, state) {
          if (state is BiometricError) {
            AppFunctions.errorMessage(context, message: state.error);
          } else if (state is BiometricNotSupported) {
            AppFunctions.errorMessage(
              context,
              message: LocaleKeys.biometrics_not_supported_on_this_device.tr(),
            );
          } else if (state is BiometricLockNotSet) {
            AppFunctions.errorMessage(
              context,
              message: LocaleKeys.please_set_a_device_lock_pin_or_pattern_first
                  .tr(),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is BiometricLoading;
          final bool switchValue = switch (state) {
            BiometricEnabled() => true,
            BiometricDisabled() => false,
            _ => settingsController.isEnabled,
          };

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderBioMetricSection(isEnableBioMetric: switchValue),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: CustomSwitchListTile(
                      title: LocaleKeys.biometric.tr().replaceFirst('b', 'B'),
                      subtitle: LocaleKeys.desc_biometric.tr(),
                      value: switchValue,
                      onChanged: isLoading
                          ? null
                          : (value) async {
                              if (value) {
                                final confirmed = await showConfirmationDialog(
                                  context,
                                );
                                if (confirmed ?? false) {
                                  await settingsController.enableBiometrics(
                                    context,
                                  );
                                }
                              } else {
                                await settingsController.disableBiometrics();
                              }
                            },
                    ),
                  ),
                  if (isLoading) ...[
                    30.ph,
                    const CircularProgressIndicator.adaptive(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
