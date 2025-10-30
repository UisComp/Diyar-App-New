
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyNumberText extends StatelessWidget {
  const EmergencyNumberText({super.key, required this.textSecondary});

  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.emergency_number.tr(),
      style: TextStyle(
        color: textSecondary,
        fontSize: 18.sp,
        letterSpacing: 1.2,
      ),
    );
  }
}