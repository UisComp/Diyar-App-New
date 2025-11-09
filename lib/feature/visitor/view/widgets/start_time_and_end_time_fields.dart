
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StartTimeAndEndTimeFields extends StatelessWidget {
  const StartTimeAndEndTimeFields({
    super.key,
    required this.visitorController,
  });

  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
    
            controller: visitorController.startTimeController,
            readOnly: true,
            onTap: () async {
              await visitorController.pickStartTime(context);
              if (visitorController.startTime != null) {
                visitorController.startTimeController.text =
                    visitorController.startTime!.format(context);
              }
            },
            validator: (value) {
              if (visitorController.startTime == null) {
                return LocaleKeys.please_select_time_range.tr();
              }
              if (ValidatorHelper.isPast(
                visitorController.startTime!,
              )) {
                return LocaleKeys.start_time_cannot_be_past.tr();
              }
              return null;
            },
            hintText: LocaleKeys.start_time.tr(),
          ),
        ),
        16.pw,
        Expanded(
          child: CustomTextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: visitorController.endTimeController,
            readOnly: true,
            onTap: () async {
              await visitorController.pickEndTime(context);
              if (visitorController.endTime != null) {
                visitorController.endTimeController.text =
                    visitorController.endTime!.format(context);
              }
            },
            validator: (value) {
              if (visitorController.endTime == null) {
                return LocaleKeys.please_select_time_range.tr();
              }
              if (!ValidatorHelper.isAfter(
                visitorController.endTime!,
                visitorController.startTime!,
              )) {
                return LocaleKeys.end_time_must_be_after_start.tr();
              }
              return null;
            },
    
            hintText: LocaleKeys.end_time.tr(),
          ),
        ),
      ],
    );
  }
}
