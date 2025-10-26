
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectAvailableFacilitiesText extends StatelessWidget {
  const SelectAvailableFacilitiesText({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.select_available_facilities.tr(),
      style: AppStyle.fontSize18Bold(context).copyWith(
        color: isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
      ),
    );
  }
}