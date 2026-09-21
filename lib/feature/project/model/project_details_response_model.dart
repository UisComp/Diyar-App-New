import 'package:diyar_app/core/model/building_models.dart';

export 'package:diyar_app/core/model/building_models.dart';

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

List<Map<String, dynamic>> _asMapList(dynamic value) => value is List
    ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
    : const [];

/// `GET /api/projects/{id}`. Signed in: only the buildings holding the
/// user's own units, each with only those units. Signed out (or owning
/// nothing here): project info, master plan and gallery, no buildings.
class ProjectDetailsResponseModel {
  final bool? success;
  final String? message;
  final ProjectData? data;

  const ProjectDetailsResponseModel({this.success, this.message, this.data});

  factory ProjectDetailsResponseModel.fromJson(Map<String, dynamic>? json) {
    final data = _asMap(json?['data']);
    return ProjectDetailsResponseModel(
      success: json?['success'] == true,
      message: json?['message']?.toString(),
      data: data == null ? null : ProjectData.fromJson(data),
    );
  }
}

class ProjectData {
  final int? id;
  final String? name;
  final String? description;

  /// The master plan the building map is drawn on.
  final ProjectMedia? mainImage;
  final List<ProjectMedia>? media;

  /// The user's buildings only. Blocks first, then towns, then villas; by
  /// code within each type.
  final List<Building> buildings;

  /// At least one shape was returned.
  final bool hasBuildingMapping;

  /// Sent whenever the project has a map (even with no shapes), so the
  /// picture's size is known. Absent when no map was drawn yet.
  final BuildingMapping? buildingMapping;

  const ProjectData({
    this.id,
    this.name,
    this.description,
    this.mainImage,
    this.media,
    this.buildings = const [],
    this.hasBuildingMapping = false,
    this.buildingMapping,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    final mainImage = _asMap(json['main_image']);
    final mapping = _asMap(json['building_mapping']);
    return ProjectData(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      mainImage: mainImage == null ? null : ProjectMedia.fromJson(mainImage),
      media: json['media'] is List
          ? _asMapList(json['media']).map(ProjectMedia.fromJson).toList()
          : null,
      buildings: _asMapList(json['buildings']).map(Building.fromJson).toList(),
      hasBuildingMapping:
          json['has_building_mapping'] == true ||
          json['has_building_mapping'] == 'true',
      buildingMapping: mapping == null
          ? null
          : BuildingMapping.fromJson(mapping),
    );
  }

  /// The gallery's images, in the dashboard's order.
  List<ProjectMedia> get gallery => [
    for (final item in media ?? const <ProjectMedia>[])
      if (item.isImage) item,
  ];

  Building? buildingById(int? id) {
    if (id == null) return null;
    for (final building in buildings) {
      if (building.id == id) return building;
    }
    return null;
  }

  /// The buildings the user actually holds a unit in. `buildings` is meant
  /// to be exactly those, but a backend that also lists neighbouring
  /// buildings sends them with an empty `units`, and those are not the
  /// user's to see on the plan or in the list.
  List<Building> get ownedBuildings => [
    for (final building in buildings)
      if (building.units.isNotEmpty) building,
  ];

  Building? ownedBuildingById(int? id) {
    if (id == null) return null;
    for (final building in buildings) {
      if (building.id == id && building.units.isNotEmpty) return building;
    }
    return null;
  }

  /// Map shapes that point at a building the user owns a unit in. Shapes for
  /// a deleted building, or for one the user owns nothing in, are skipped:
  /// the plan highlights their own units and nothing else.
  List<(BuildingShape, Building)> get linkedShapes {
    final mapping = buildingMapping;
    if (!hasBuildingMapping || mapping == null) return const [];
    return [
      for (final shape in mapping.shapes)
        if (shape.points.length >= 3 &&
            ownedBuildingById(shape.buildingId) != null)
          (shape, ownedBuildingById(shape.buildingId)!),
    ];
  }
}

class BuildingMapping {
  final String? version;
  final int? imageWidth;
  final int? imageHeight;
  final List<BuildingShape> shapes;

  const BuildingMapping({
    this.version,
    this.imageWidth,
    this.imageHeight,
    this.shapes = const [],
  });

  factory BuildingMapping.fromJson(Map<String, dynamic> json) =>
      BuildingMapping(
        version: json['version']?.toString(),
        imageWidth: _toInt(json['imageWidth'] ?? json['image_width']),
        imageHeight: _toInt(json['imageHeight'] ?? json['image_height']),
        shapes: _asMapList(json['shapes']).map(BuildingShape.fromJson).toList(),
      );

  /// width / height of the master plan, when known and sane.
  double? get aspectRatio {
    final w = imageWidth, h = imageHeight;
    if (w == null || h == null || w <= 0 || h <= 0) return null;
    return w / h;
  }
}

/// A shape on the master plan. `rect` and `polygon` both arrive as a list of
/// `[x, y]` points normalised to 0–1, so both are drawn as polygons.
class BuildingShape {
  final String? id;
  final String? shapeType;
  final int? buildingId;
  final List<List<double>> points;

  const BuildingShape({
    this.id,
    this.shapeType,
    this.buildingId,
    this.points = const [],
  });

  factory BuildingShape.fromJson(Map<String, dynamic> json) {
    final raw = json['points'];
    final points = <List<double>>[];
    if (raw is List) {
      for (final p in raw) {
        if (p is List && p.length >= 2 && p[0] is num && p[1] is num) {
          points.add([(p[0] as num).toDouble(), (p[1] as num).toDouble()]);
        }
      }
    }
    return BuildingShape(
      id: json['id']?.toString(),
      shapeType: (json['shapeType'] ?? json['shape_type'])?.toString(),
      buildingId: _toInt(json['buildingId'] ?? json['building_id']),
      points: points,
    );
  }
}

class ProjectMedia {
  final int? id;
  final String? name;
  final String? fileName;
  final String? url;
  final int? size;
  final String? mimeType;

  const ProjectMedia({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  /// The gallery only takes images; anything else is skipped. Older
  /// backends sent no `mime_type`, so a missing one counts as an image.
  bool get isImage =>
      (url?.isNotEmpty ?? false) &&
      (mimeType == null || mimeType!.startsWith('image/'));

  factory ProjectMedia.fromJson(Map<String, dynamic> json) => ProjectMedia(
    id: _toInt(json['id']),
    name: json['name']?.toString(),
    fileName: json['file_name']?.toString(),
    url: json['url']?.toString(),
    size: _toInt(json['size']),
    mimeType: json['mime_type']?.toString(),
  );
}
