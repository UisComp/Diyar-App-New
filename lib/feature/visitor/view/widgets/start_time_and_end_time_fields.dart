import 'package:diyar_app/core/extension/sized_box.dart';

import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StartTimeAndEndTimeFields extends StatelessWidget {
  const StartTimeAndEndTimeFields({super.key, required this.visitorController});

  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStartTimeField(context)),
        16.pw,
        Expanded(child: _buildEndTimeField(context)),
      ],
    );
  }

  Widget _buildStartTimeField(BuildContext context) {
    return CustomTextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: visitorController.startTimeController,
      readOnly: true,
      hintText: LocaleKeys.start_time.tr(),
      onTap: () async {
        await visitorController.pickStartTime(context);
        if (visitorController.startTime != null) {
          visitorController.startTimeController.text = visitorController
              .startTime!
              .format(context);
        }
      },
      validator: _validateStartTime,
    );
  }

  Widget _buildEndTimeField(BuildContext context) {
    return CustomTextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: visitorController.endTimeController,
      readOnly: true,
      hintText: LocaleKeys.end_time.tr(),
      onTap: () async {
        await visitorController.pickEndTime(context);
        if (visitorController.endTime != null) {
          visitorController.endTimeController.text = visitorController.endTime!
              .format(context);
        }
      },
      validator: _validateEndTime,
    );
  }

  String? _validateStartTime(String? value) {
    // Check if start time is selected
    if (visitorController.startTime == null) {
      return LocaleKeys.please_select_time_range.tr();
    }

    // Check if date range is selected
    // if (visitorController.selectedDateRange == null) {
    //   return LocaleKeys.please_select_date_range.tr();
    // }

    // Check if start time is in the past
    // if (ValidatorHelper.isPastDateTime(
    //   visitorController.selectedDateRange!.start,
    //   visitorController.startTime!,
    // )) {
    //   return LocaleKeys.start_time_cannot_be_past.tr();
    // }

    // Validate against end time if both are selected
    // if (visitorController.endTime != null) {
    //   if (!ValidatorHelper.isAfter(
    //     visitorController.selectedDateRange!.start,
    //     visitorController.startTime!,
    //     visitorController.endTime!,
    //   )) {
    //     return LocaleKeys.start_time_must_be_before_end.tr();
    //   }
    // }

    return null;
  }

  String? _validateEndTime(String? value) {
    // Check if end time is selected
    if (visitorController.endTime == null) {
      return LocaleKeys.please_select_time_range.tr();
    }

    // Check if date range is selected
    // if (visitorController.selectedDateRange == null) {
    //   return LocaleKeys.please_select_date_range.tr();
    // }

    // Only validate against start time if start time is selected
    // if (visitorController.startTime != null) {
    //   if (!ValidatorHelper.isAfter(
    //     visitorController.selectedDateRange!.start,
    //     visitorController.startTime!,
    //     visitorController.endTime!,
    //   )) {
    //     return LocaleKeys.end_time_must_be_after_start.tr();
    //   }
    // }

    return null;
  }
}
