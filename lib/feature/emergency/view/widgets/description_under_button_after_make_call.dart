import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DescriptionUnderButtonAfterMakeCall extends StatelessWidget {
  const DescriptionUnderButtonAfterMakeCall({
    super.key,
    required double holdProgress,
    required this.remainingSeconds,
  }) : _holdProgress = holdProgress;

  final double _holdProgress;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return Text(
      _holdProgress > 0
          ? "${LocaleKeys.hold_to_activate.tr()} (${remainingSeconds}s)"
          : LocaleKeys.press_and_hold_to_start.tr(),
      style: AppStyle.fontSize16Regular(context),
    );
  }
}
