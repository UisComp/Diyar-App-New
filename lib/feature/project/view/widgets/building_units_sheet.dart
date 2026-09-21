import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/unit_image_gallery.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/profile/view/widgets/unit_info_card.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class UnitStatusColors {
  static const Color available = Color(0xFF1E9E5A);
  static const Color reserved = Color(0xFFE69A00);
  static const Color sold = Color(0xFF8A94A6);

  static Color of(UnitStatus status) => switch (status) {
    UnitStatus.available => available,
    UnitStatus.reserved => reserved,
    UnitStatus.sold || UnitStatus.unknown => sold,
  };
}

/// The user's own units in one building, in full, grouped by floor. The API
/// only sends units the user owns, so nothing here belongs to anyone else.
///
/// When [onViewNews] is set, each unit gets a "View unit news" button.
class BuildingUnitsSheet extends StatelessWidget {
  const BuildingUnitsSheet({
    super.key,
    required this.building,
    required this.units,
    this.onViewNews,
  });

  final Building building;

  /// All of [building]'s units, or just the one the user tapped.
  final List<UnitSummary> units;
  final ValueChanged<UnitSummary>? onViewNews;

  static Future<void> show(
    BuildContext context,
    Building building, {
    List<UnitSummary>? units,
    ValueChanged<UnitSummary>? onViewNews,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppSurface.of(context).card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BuildingUnitsSheet(
        building: building,
        units: units ?? building.units,
        onViewNews: onViewNews,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final groups = Building(type: building.type, units: units).unitsByFloor;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: surface.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            16.ph,
            Row(
              children: [
                Expanded(
                  child: Text(
                    building.label,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: surface.textPrimary,
                    ),
                  ),
                ),
                if (building.type != BuildingType.unknown)
                  _Chip(
                    label: building.type.labelKey.tr(),
                    color: AppColors.primaryColor,
                  ),
              ],
            ),
            18.ph,
            if (units.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: surface.border),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  LocaleKeys.no_units_in_building.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: surface.textSecondary,
                  ),
                ),
              )
            else
              for (final (floor, floorUnits) in groups) ...[
                if (groups.length > 1 &&
                    floorLabel(floor, building.type) != null) ...[
                  Text(
                    floorLabel(floor, building.type)!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: surface.textSecondary,
                    ),
                  ),
                  8.ph,
                ],
                for (final unit in floorUnits) ...[
                  OwnedUnitDetails(
                    unit: unit,
                    building: building,
                    onViewNews: onViewNews == null
                        ? null
                        : () => onViewNews!(unit),
                  ),
                  16.ph,
                ],
              ],
          ],
        ),
      ),
    );
  }
}

/// Everything the owner can see about one unit: picture, where it is and
/// the contract breakdown.
class OwnedUnitDetails extends StatelessWidget {
  const OwnedUnitDetails({
    super.key,
    required this.unit,
    required this.building,
    this.onViewNews,
  });

  final UnitSummary unit;
  final Building building;
  final VoidCallback? onViewNews;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final money = <(String, double, bool)>[
      if (unit.unitValue != null)
        (LocaleKeys.unit_value.tr(), unit.unitValue!, false),
      if (unit.maintenanceDepositAmount != null)
        (
          LocaleKeys.type_maintenance_deposit.tr(),
          unit.maintenanceDepositAmount!,
          false,
        ),
      if (unit.clubHouseAmount != null)
        (LocaleKeys.type_club_house.tr(), unit.clubHouseAmount!, false),
      if (unit.contractTotal != null)
        (LocaleKeys.contract_total.tr(), unit.contractTotal!, true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnitImageGallery(
          images: unit.images,
          title: unit.label,
          height: 170.h,
        ),
        12.ph,
        Text(
          unit.label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
        10.ph,
        // Status is left out: an owned unit is always "sold".
        UnitInfoCard(
          building: unit.building ?? building,
          code: unit.code,
          floor: unit.floor,
        ),
        if (money.isNotEmpty) ...[
          10.ph,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: surface.cardDecoration(),
            child: Column(
              children: [
                for (var i = 0; i < money.length; i++) ...[
                  if (i > 0) Divider(height: 18.h, color: surface.border),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          money[i].$1,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: money[i].$3
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: money[i].$3
                                ? surface.textPrimary
                                : surface.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        FinanceFormatter.money(money[i].$2),
                        style: TextStyle(
                          fontSize: money[i].$3 ? 15.sp : 14.sp,
                          fontWeight: FontWeight.w700,
                          color: money[i].$3
                              ? AppColors.primaryColor
                              : surface.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
        if (onViewNews != null) ...[
          12.ph,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewNews,
              icon: const Icon(Icons.newspaper_rounded),
              label: Text(LocaleKeys.view_unit_news.tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
