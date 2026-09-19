import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Project → Building → Unit (Swagger schemas `Building` and `UnitSummary`).

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? _toStr(dynamic value) {
  final s = value?.toString();
  return (s == null || s.isEmpty) ? null : s;
}

enum BuildingType {
  block,
  town,
  villa,
  unknown;

  static BuildingType parse(dynamic value) => switch (value) {
    'block' => BuildingType.block,
    'town' => BuildingType.town,
    'villa' => BuildingType.villa,
    _ => BuildingType.unknown,
  };

  String get labelKey => switch (this) {
    BuildingType.block => LocaleKeys.building_type_block,
    BuildingType.town => LocaleKeys.building_type_town,
    BuildingType.villa => LocaleKeys.building_type_villa,
    BuildingType.unknown => LocaleKeys.unknown,
  };
}

enum UnitStatus {
  available,
  reserved,
  sold,
  unknown;

  static UnitStatus parse(dynamic value) => switch (value) {
    'available' => UnitStatus.available,
    'reserved' => UnitStatus.reserved,
    'sold' => UnitStatus.sold,
    _ => UnitStatus.unknown,
  };

  String get labelKey => switch (this) {
    UnitStatus.available => LocaleKeys.unit_status_available,
    UnitStatus.reserved => LocaleKeys.unit_status_reserved,
    UnitStatus.sold => LocaleKeys.unit_status_sold,
    UnitStatus.unknown => LocaleKeys.unknown,
  };
}

/// Localized floor name. Blocks: Ground / First / Second / Third / Floor N.
/// Towns: Ground / Upper. Villas have no floor (null).
String? floorLabel(int? floor, BuildingType type) {
  if (floor == null) return null;
  if (type == BuildingType.town) {
    return (floor == 0 ? LocaleKeys.floor_ground : LocaleKeys.floor_upper).tr();
  }
  return switch (floor) {
    0 => LocaleKeys.floor_ground.tr(),
    1 => LocaleKeys.floor_first.tr(),
    2 => LocaleKeys.floor_second.tr(),
    3 => LocaleKeys.floor_third.tr(),
    _ => LocaleKeys.floor_number.tr(args: ['$floor']),
  };
}

class Building {
  final int? id;
  final BuildingType type;
  final String? code;
  final String? name;
  final String? _label;

  /// Only in `GET /api/projects/{id}`: the signed-in user's own units in
  /// this building, in full. Ground floor first, then by code.
  final List<UnitSummary> units;

  const Building({
    this.id,
    this.type = BuildingType.unknown,
    this.code,
    this.name,
    String? label,
    this.units = const [],
  }) : _label = label;

  factory Building.fromJson(Map<String, dynamic> json) {
    final units = json['units'];
    return Building(
      id: _toInt(json['id']),
      type: BuildingType.parse(json['type']),
      code: _toStr(json['code']),
      name: _toStr(json['name']),
      label: _toStr(json['label']),
      units: units is List
          ? units
                .whereType<Map>()
                .map((u) => UnitSummary.fromJson(Map<String, dynamic>.from(u)))
                .toList()
          : const [],
    );
  }

  /// What to show: the API's label, falling back to name then code.
  String get label => _label ?? name ?? code ?? '';

  /// Units grouped by floor, ground first. Villas/unknown floors come as a
  /// single `null` group.
  List<(int?, List<UnitSummary>)> get unitsByFloor {
    final groups = <int?, List<UnitSummary>>{};
    for (final unit in units) {
      groups.putIfAbsent(unit.floor, () => []).add(unit);
    }
    final floors = groups.keys.toList()
      ..sort((a, b) => (a ?? -1).compareTo(b ?? -1));
    return [for (final f in floors) (f, groups[f]!)];
  }
}

/// A unit as other payloads refer to it. The money fields and image are
/// only sent to the unit's owner (`GET /api/projects/{id}` for a signed-in
/// user, `GET /api/units/{id}`); elsewhere they are null.
class UnitSummary {
  final int? id;
  final String? code;
  final String? name;
  final String? _label;

  /// 0 is the ground floor; null for villas.
  final int? floor;
  final UnitStatus status;

  /// In `GET /api/projects/{id}` this is the unit's own building, so it is
  /// null there only on older backends.
  final Building? building;

  /// EGP. Null when staff haven't entered it yet.
  final double? unitValue;
  final double? maintenanceDepositAmount;
  final double? clubHouseAmount;

  /// Unit value + Maintenance Deposit + Club House.
  final double? contractTotal;
  final String? imageUrl;

  const UnitSummary({
    this.id,
    this.code,
    this.name,
    String? label,
    this.floor,
    this.status = UnitStatus.unknown,
    this.building,
    this.unitValue,
    this.maintenanceDepositAmount,
    this.clubHouseAmount,
    this.contractTotal,
    this.imageUrl,
  }) : _label = label;

  factory UnitSummary.fromJson(Map<String, dynamic> json) {
    final building = json['building'];
    final image = json['main_image'];
    return UnitSummary(
      id: _toInt(json['id']),
      code: _toStr(json['code']),
      name: _toStr(json['name']),
      label: _toStr(json['label']),
      floor: _toInt(json['floor']),
      status: UnitStatus.parse(json['status']),
      building: building is Map
          ? Building.fromJson(Map<String, dynamic>.from(building))
          : null,
      unitValue: _toDouble(json['unit_value']),
      maintenanceDepositAmount: _toDouble(json['maintenance_deposit_amount']),
      clubHouseAmount: _toDouble(json['club_house_amount']),
      contractTotal: _toDouble(json['contract_total']),
      imageUrl: image is Map ? _toStr(image['url']) : null,
    );
  }

  /// "Town 1 · T-1-G": the API's label, falling back to name then code.
  String get label => _label ?? name ?? code ?? '';

  bool get hasMoney =>
      unitValue != null ||
      maintenanceDepositAmount != null ||
      clubHouseAmount != null ||
      contractTotal != null;
}
