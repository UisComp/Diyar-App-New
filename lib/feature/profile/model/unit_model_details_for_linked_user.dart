import 'package:diyar_app/core/model/building_models.dart';

export 'package:diyar_app/core/model/building_models.dart';

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

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

List<Map<String, dynamic>> _asMapList(dynamic value) => value is List
    ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
    : const [];

/// `GET /api/units/{id}`.
class UnitModelDetailsForLinkedUserResponseModel {
  final bool? success;
  final String? message;
  final UnitData? data;

  UnitModelDetailsForLinkedUserResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory UnitModelDetailsForLinkedUserResponseModel.fromJson(dynamic json) {
    final map = _asMap(json);
    final data = _asMap(map?['data']);
    return UnitModelDetailsForLinkedUserResponseModel(
      success: map?['success'] == true,
      message: map?['message']?.toString(),
      data: data == null ? null : UnitData.fromJson(data),
    );
  }
}

/// The full unit, for its owner (Swagger `Unit`): the [UnitSummary] fields
/// plus ids, money, image and news.
class UnitData {
  final int? id;
  final String? code;
  final String? name;
  final String? _label;

  /// 0 is the ground floor; null for villas.
  final int? floor;
  final UnitStatus status;
  final int? projectId;
  final int? buildingId;
  final Building? building;
  final int? userId;
  final double? unitValue;
  final double? maintenanceDepositAmount;
  final double? clubHouseAmount;

  /// Unit value + Maintenance Deposit + Club House.
  final double? contractTotal;
  final Media? mainImage;
  final List<News>? news;

  UnitData({
    this.id,
    this.code,
    this.name,
    String? label,
    this.floor,
    this.status = UnitStatus.unknown,
    this.projectId,
    this.buildingId,
    this.building,
    this.userId,
    this.unitValue,
    this.maintenanceDepositAmount,
    this.clubHouseAmount,
    this.contractTotal,
    this.mainImage,
    this.news,
  }) : _label = label;

  factory UnitData.fromJson(Map<String, dynamic> json) {
    final building = _asMap(json['building']);
    final mainImage = _asMap(json['main_image']);
    return UnitData(
      id: _toInt(json['id']),
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      label: json['label']?.toString(),
      floor: _toInt(json['floor']),
      status: UnitStatus.parse(json['status']),
      projectId: _toInt(json['project_id']),
      buildingId: _toInt(json['building_id']),
      building: building == null ? null : Building.fromJson(building),
      userId: _toInt(json['user_id']),
      unitValue: _toDouble(json['unit_value']),
      maintenanceDepositAmount: _toDouble(json['maintenance_deposit_amount']),
      clubHouseAmount: _toDouble(json['club_house_amount']),
      contractTotal: _toDouble(json['contract_total']),
      mainImage: mainImage == null ? null : Media.fromJson(mainImage),
      news: json['news'] is List
          ? _asMapList(json['news']).map(News.fromJson).toList()
          : null,
    );
  }

  /// "Town 1 · T-1-G": the API's label, falling back to name then code.
  String get label => _label ?? name ?? code ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'label': _label,
    'floor': floor,
    'status': status.name,
    'project_id': projectId,
    'building_id': buildingId,
    'user_id': userId,
    'unit_value': unitValue,
    'maintenance_deposit_amount': maintenanceDepositAmount,
    'club_house_amount': clubHouseAmount,
    'contract_total': contractTotal,
  };
}

class Media {
  final int? id;
  final String? name;
  final String? fileName;
  final String? url;
  final int? size;
  final String? uploadedAt;

  Media({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: _toInt(json['id']),
    name: json['name']?.toString(),
    fileName: json['file_name']?.toString(),
    url: json['url']?.toString(),
    size: _toInt(json['size']),
    uploadedAt: json['uploaded_at']?.toString(),
  );
}

class News {
  final int? id;
  final String? title;
  final String? content;
  final String? newsDate;
  final List<Media>? media;

  /// News is public, so its unit is a [UnitSummary] (no owner, no money).
  final UnitSummary? unit;
  final NewsProject? project;

  News({
    this.id,
    this.title,
    this.content,
    this.newsDate,
    this.media,
    this.unit,
    this.project,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    final unit = _asMap(json['unit']);
    final project = _asMap(json['project']);
    return News(
      id: _toInt(json['id']),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      newsDate: json['news_date']?.toString(),
      media: json['media'] is List
          ? _asMapList(json['media']).map(Media.fromJson).toList()
          : null,
      unit: unit == null ? null : UnitSummary.fromJson(unit),
      project: project == null ? null : NewsProject.fromJson(project),
    );
  }
}

class NewsProject {
  final int? id;
  final String? name;
  final String? description;
  final Media? mainImage;
  final bool hasBuildingMapping;

  NewsProject({
    this.id,
    this.name,
    this.description,
    this.mainImage,
    this.hasBuildingMapping = false,
  });

  factory NewsProject.fromJson(Map<String, dynamic> json) {
    final mainImage = _asMap(json['main_image']);
    return NewsProject(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      mainImage: mainImage == null ? null : Media.fromJson(mainImage),
      hasBuildingMapping: json['has_building_mapping'] == true,
    );
  }
}
