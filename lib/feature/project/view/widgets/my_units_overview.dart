import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The user's own units in the project, grouped by building and floor.
/// The API only returns buildings holding at least one of them.
class MyUnitsOverview extends StatelessWidget {
  const MyUnitsOverview({
    super.key,
    required this.buildings,
    required this.onUnitTapped,
    this.selectedUnitId,
    this.onShowOnMap,
    this.mappedBuildingIds = const {},
  });

  final List<Building> buildings;
  final void Function(Building building, UnitSummary unit) onUnitTapped;

  /// Zooms the master plan to the unit's building. Offered only for the
  /// buildings in [mappedBuildingIds] (those drawn on the plan).
  final ValueChanged<Building>? onShowOnMap;
  final Set<int> mappedBuildingIds;

  /// The unit whose news the timeline shows.
  final int? selectedUnitId;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final building in buildings)
          if (building.units.isNotEmpty) ...[
            Row(
              children: [
                Flexible(
                  child: Text(
                    building.label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: surface.textPrimary,
                    ),
                  ),
                ),
                if (building.type != BuildingType.unknown) ...[
                  6.pw,
                  Text(
                    '· ${building.type.labelKey.tr()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: surface.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            8.ph,
            for (final (floor, units) in building.unitsByFloor)
              for (final unit in units) ...[
                _OwnedUnitTile(
                  unit: unit,
                  floorText: floorLabel(floor, building.type),
                  selected: unit.id != null && unit.id == selectedUnitId,
                  onTap: () => onUnitTapped(building, unit),
                  onShowOnMap:
                      onShowOnMap != null &&
                          mappedBuildingIds.contains(building.id)
                      ? () => onShowOnMap!(building)
                      : null,
                ),
                8.ph,
              ],
            8.ph,
          ],
      ],
    );
  }
}

class _OwnedUnitTile extends StatelessWidget {
  const _OwnedUnitTile({
    required this.unit,
    required this.onTap,
    this.floorText,
    this.selected = false,
    this.onShowOnMap,
  });

  final UnitSummary unit;
  final String? floorText;
  final VoidCallback onTap;
  final bool selected;
  final VoidCallback? onShowOnMap;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final imageUrl = unit.imageUrl;
    final total = unit.contractTotal ?? unit.unitValue;
    final subtitle = [
      if (unit.code case final String code) code,
      if (floorText case final String floor) floor,
    ].join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryColor.withValues(alpha: 0.10)
                : surface.card,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: selected ? AppColors.primaryColor : surface.border,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SizedBox(
                  width: 56.r,
                  height: 56.r,
                  child: imageUrl != null
                      ? CustomCachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 56.r,
                          height: 56.r,
                          fit: BoxFit.cover,
                          // The row opens the unit sheet, which shows the
                          // picture large and zoomable.
                          enablePreview: false,
                        )
                      : ColoredBox(
                          color: AppColors.primaryColor.withValues(alpha: 0.10),
                          child: Icon(
                            Icons.home_work_outlined,
                            color: AppColors.primaryColor,
                            size: 26.sp,
                          ),
                        ),
                ),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: surface.textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      2.ph,
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: surface.textSecondary,
                        ),
                      ),
                    ],
                    if (total != null) ...[
                      2.ph,
                      Text(
                        FinanceFormatter.money(total),
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onShowOnMap != null) ...[
                IconButton(
                  tooltip: LocaleKeys.show_on_map.tr(),
                  onPressed: onShowOnMap,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.10,
                    ),
                  ),
                  icon: Icon(
                    Icons.location_searching_rounded,
                    size: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                4.pw,
              ],
              // Mirrored automatically in Arabic.
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: surface.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
