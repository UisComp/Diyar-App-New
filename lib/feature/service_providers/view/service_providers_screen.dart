import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({super.key});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  final Map<String, bool> selectedProviders = {
    "Plumber": false,
    "Electrician": false,
    "Cleaner": false,
    "Painter": false,
    "Gardener": false,
  };

  final Map<String, IconData> icons = {
    "Plumber": Icons.plumbing,
    "Electrician": Icons.electric_bolt,
    "Cleaner": Icons.cleaning_services,
    "Painter": Icons.format_paint,
    "Gardener": Icons.grass,
  };

  final Map<String, String> descriptions = {
    "Plumber": "Fixes leaks, installs pipes and maintains plumbing systems.",
    "Electrician":
        "Handles electrical repairs, installations, and safety checks.",
    "Cleaner": "Keeps your space spotless and hygienic.",
    "Painter": "Provides high-quality interior and exterior painting services.",
    "Gardener": "Takes care of gardens, lawns, and outdoor plants.",
  };

  final Map<String, TextEditingController> descControllers = {};

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (var name in selectedProviders.keys) {
      descControllers[name] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in descControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.serviceProviders.tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                  itemCount: selectedProviders.length,
                  itemBuilder: (context, index) {
                    final name = selectedProviders.keys.elementAt(index);
                    final selected = selectedProviders[name]!;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryColor.withOpacity(0.12)
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
                              color: AppColors.primaryColor.withOpacity(0.15),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              value: selected,
                              onChanged: (value) {
                                setState(() {
                                  selectedProviders[name] = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryColor,
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: selected
                                        ? AppColors.primaryColor
                                        : Colors.grey.withOpacity(0.4),
                                    child: Icon(
                                      icons[name],
                                      color: Colors.white,
                                    ),
                                  ),
                                  12.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
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
                                        4.ph,
                                        Text(
                                          descriptions[name]!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: isDark
                                                    ? AppColors
                                                          .darkTextSecondary
                                                    : AppColors
                                                          .lightTextSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected) ...[
                              8.ph,

                              10.ph,
                              CustomTextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: descControllers[name],
                                hintText: LocaleKeys.describe_your_requirements
                                    .tr(),
                                validator: (value) {
                                  if ((value ?? "").isEmpty) {
                                    return LocaleKeys.description_is_required
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                              8.ph,
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              16.ph,
              CustomButton(
                buttonColor: AppColors.primaryColor,
                buttonText: LocaleKeys.request_now.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final selected = selectedProviders.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          selected.isNotEmpty
                              ? "Submitted: ${selected.join(', ')}"
                              : "No providers selected",
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.greenColor,
                      ),
                    );
                  }
                },
              ),
              16.ph,
            ],
          ),
        ),
      ),
    );
  }
}
