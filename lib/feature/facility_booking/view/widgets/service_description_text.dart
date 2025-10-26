import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDescriptionText extends StatelessWidget {
  const ServiceDescriptionText({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.service_description.tr(),
      style: AppStyle.fontSize16Regular(context).copyWith(
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        fontSize: 13.5.sp,
        height: 1.4,
      ),
    );
  }
}
