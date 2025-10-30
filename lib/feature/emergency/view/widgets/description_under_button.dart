
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionUnderButton extends StatelessWidget {
  const DescriptionUnderButton({
    super.key,
    required this.cardColor,
    required this.activationDuration,
  });

  final Color cardColor;
  final int activationDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0.sp),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(16.sp),
        child: Text(
          "${LocaleKeys.hold_the_red_button.tr()} ${activationDuration}s ${LocaleKeys.to_make_a_call.tr()} . "
          "${LocaleKeys.release_to_cancel.tr()}",
          style: AppStyle.fontSize16Regular(context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

