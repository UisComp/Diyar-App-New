import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/project/view/widgets/building_units_sheet.dart'
    show UnitStatusColors;
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Where a unit is: its building, code, floor and sales status.
class UnitInfoCard extends StatelessWidget {
  const UnitInfoCard({
    super.key,
    this.building,
    this.code,
    this.floor,
    this.status = UnitStatus.unknown,
  });

  final Building? building;
  final String? code;
  final int? floor;
  final UnitStatus status;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final type = building?.type ?? BuildingType.unknown;
    final floorText = floorLabel(floor, type);
    final rows = <(String, String)>[
      if (building != null)
        (
          LocaleKeys.building.tr().replaceAll(':', '').trim(),
          type == BuildingType.unknown
              ? building!.label
              : '${building!.label} · ${type.labelKey.tr()}',
        ),
      if (code != null) (LocaleKeys.unit_code.tr(), code!),
      if (floorText != null) (LocaleKeys.floor.tr(), floorText),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: surface.cardDecoration(),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 18.h, color: surface.border),
            Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: surface.textSecondary,
                    ),
                  ),
                ),
                Text(
                  rows[i].$2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: surface.textPrimary,
                  ),
                ),
              ],
            ),
          ],
          if (status != UnitStatus.unknown) ...[
            if (rows.isNotEmpty) Divider(height: 18.h, color: surface.border),
            Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.status.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: surface.textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: UnitStatusColors.of(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    status.labelKey.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: UnitStatusColors.of(status),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
