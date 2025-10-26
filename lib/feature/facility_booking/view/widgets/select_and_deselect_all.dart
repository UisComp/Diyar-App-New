
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectAndDeselectAll extends StatefulWidget {
  const SelectAndDeselectAll({
    super.key,
    required this.allSelected,
    required this.toggleSelectAll,
  });
  final bool allSelected;
  final VoidCallback toggleSelectAll;
  @override
  State<SelectAndDeselectAll> createState() => _SelectAndDeselectAllState();
}

class _SelectAndDeselectAllState extends State<SelectAndDeselectAll> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: widget.toggleSelectAll,
        icon: Icon(
          widget.allSelected ? Icons.deselect : Icons.done_all,
          color: AppColors.primaryColor,
        ),
        label: Text(
          widget.allSelected
              ? LocaleKeys.deselect_all.tr()
              : LocaleKeys.select_all.tr(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
