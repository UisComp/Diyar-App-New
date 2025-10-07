import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
    required this.subtitle,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: AppStyle.fontSize16Regular(context)),
      subtitle: Text(
        subtitle,
        style: AppStyle.fontSize14RegularNewsReader(context),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor : AppColors.primaryColor,
      inactiveThumbColor: AppColors.whiteColor,
      activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.3),
      inactiveTrackColor: AppColors.greyColor.withValues(alpha: 0.4),
    );
  }
}
