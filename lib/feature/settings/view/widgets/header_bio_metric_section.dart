import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderBioMetricSection extends StatelessWidget {
  const HeaderBioMetricSection({super.key, required this.isEnableBioMetric});
  final bool isEnableBioMetric;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.fingerprint_rounded,
          size: 80.r,
          color: isEnableBioMetric
              ? AppColors.primaryColor
              : AppColors.greyColor,
        ),
        16.ph,
        Text(
          LocaleKeys.biometric.tr().replaceFirst('b', 'B'),
          style: AppStyle.fontSize22Bold(context)
        ),
        8.ph,
        Text(
          LocaleKeys.enableBiometricTextInDialog.tr(),
          style: AppStyle.fontSize16Regular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
