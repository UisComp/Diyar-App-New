import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartTimeAndEndTimeFields extends StatelessWidget {
  const StartTimeAndEndTimeFields({super.key, required this.visitorController});

  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildStartTimeField(context)),
        12.pw,
        Expanded(child: _buildEndTimeField(context)),
      ],
    );
  }

  Widget _buildStartTimeField(BuildContext context) {
    return CustomTextFormField(
      horizontalPadding: 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: visitorController.startTimeController,
      readOnly: true,
      hintText: LocaleKeys.start_time.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      prefixIcon: Icon(
        Icons.play_circle_outline_rounded,
        size: 20.sp,
        color: AppColors.primaryColor,
      ),
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
      horizontalPadding: 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: visitorController.endTimeController,
      readOnly: true,
      hintText: LocaleKeys.end_time.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      prefixIcon: Icon(
        Icons.stop_circle_outlined,
        size: 20.sp,
        color: AppColors.primaryColor,
      ),
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
    if (visitorController.startTime == null) {
      return LocaleKeys.please_select_time_range.tr();
    }
    return null;
  }

  String? _validateEndTime(String? value) {
    if (visitorController.endTime == null) {
      return LocaleKeys.please_select_time_range.tr();
    }
    return null;
  }
}
