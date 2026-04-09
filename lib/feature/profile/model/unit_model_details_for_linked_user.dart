import 'package:json_annotation/json_annotation.dart';

part 'unit_model_details_for_linked_user.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitModelDetailsForLinkedUserResponseModel {
  final bool? success;
  final String? message;
  final UnitData? data;

  UnitModelDetailsForLinkedUserResponseModel({this.success, this.message, this.data});

  factory UnitModelDetailsForLinkedUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelDetailsForLinkedUserResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnitModelDetailsForLinkedUserResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnitData {
  final int? id;
  final String? name;
  final String? building;
  final String? number;
  @JsonKey(name: 'project_id')
  final String? projectId;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'unit_value')
  final double? unitValue;
  @JsonKey(name: 'down_payment')
  final double? downPayment;
  @JsonKey(name: 'interest_rate')
  final double? interestRate;
  @JsonKey(name: 'installments_count')
  final int? installmentCount;
  @JsonKey(name: 'first_installment_date')
  final String? firstInstallmentDate;
  @JsonKey(name: 'main_image')
  final Media? mainImage;
  final List<News>? news;

  UnitData({
    this.id,
    this.name,
    this.building,
    this.number,
    this.projectId,
    this.userId,
    this.unitValue,
    this.downPayment,
    this.interestRate,
    this.installmentCount,
    this.firstInstallmentDate,
    this.mainImage,
    this.news,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      building: json['building']?.toString(),
      number: json['number']?.toString(),
      projectId: json['project_id']?.toString(),
      userId: json['user_id']?.toString(),
      unitValue: _toDouble(json['unit_value']),
      downPayment: _toDouble(json['down_payment']),
      interestRate: _toDouble(json['interest_rate']),
      installmentCount: _toInt(json['installments_count']),
      firstInstallmentDate: json['first_installment_date']?.toString(),
      mainImage: json['main_image'] != null ? Media.fromJson(json['main_image']) : null,
      news: json['news'] != null
          ? (json['news'] as List).map((e) => News.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$UnitDataToJson(this);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class Media {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final String? size;
  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  Media({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: UnitData._toInt(json['id']),
      name: json['name']?.toString(),
      fileName: json['file_name']?.toString(),
      url: json['url']?.toString(),
      size: json['size']?.toString(),
      uploadedAt: json['uploaded_at']?.toString(),
    );
  }
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable(explicitToJson: true)
class News {
  final int? id;
  final String? title;
  final String? content;
  @JsonKey(name: 'news_date')
  final String? newsDate;
  final List<Media>? media;
  final UnitData? unit;
  final Project? project;

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
    return News(
      id: UnitData._toInt(json['id']),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      newsDate: json['news_date']?.toString(),
      media: json['media'] != null ? (json['media'] as List).map((e) => Media.fromJson(e)).toList() : null,
      unit: json['unit'] != null ? UnitData.fromJson(json['unit']) : null,
      project: json['project'] != null ? Project.fromJson(json['project']) : null,
    );
  }
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Project {
  final int? id;
  final String? name;
  final String? description;
  @JsonKey(name: 'main_image')
  final Media? mainImage;
  final List<Media>? media;
  @JsonKey(name: 'has_unit_mapping')
  final bool? hasUnitMapping;
  @JsonKey(name: 'unit_mapping')
  final UnitMapping? unitMapping;

  Project({
    this.id,
    this.name,
    this.description,
    this.mainImage,
    this.media,
    this.hasUnitMapping,
    this.unitMapping,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: UnitData._toInt(json['id']),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      mainImage: json['main_image'] != null ? Media.fromJson(json['main_image']) : null,
      media: json['media'] != null ? (json['media'] as List).map((e) => Media.fromJson(e)).toList() : null,
      hasUnitMapping: json['has_unit_mapping'] == true || json['has_unit_mapping'] == 'true',
      unitMapping: json['unit_mapping'] != null ? UnitMapping.fromJson(json['unit_mapping']) : null,
    );
  }
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnitMapping {
  final String? version;
  final int? imageWidth;
  final int? imageHeight;
  final List<Shape>? shapes;

  UnitMapping({this.version, this.imageWidth, this.imageHeight, this.shapes});

  factory UnitMapping.fromJson(Map<String, dynamic> json) {
    return UnitMapping(
      version: json['version']?.toString(),
      imageWidth: UnitData._toInt(json['imageWidth']) ?? UnitData._toInt(json['image_width']),
      imageHeight: UnitData._toInt(json['imageHeight']) ?? UnitData._toInt(json['image_height']),
      shapes: json['shapes'] != null ? (json['shapes'] as List).map((e) => Shape.fromJson(e)).toList() : null,
    );
  }
  Map<String, dynamic> toJson() => _$UnitMappingToJson(this);
}

@JsonSerializable()
class Shape {
  final String? id;
  final String? shapeType;
  final int? unitId;
  final List<List<double>>? points;

  Shape({this.id, this.shapeType, this.unitId, this.points});

  factory Shape.fromJson(Map<String, dynamic> json) {
    return Shape(
      id: json['id']?.toString(),
      shapeType: json['shapeType']?.toString() ?? json['shape_type']?.toString(),
      unitId: UnitData._toInt(json['unitId']) ?? UnitData._toInt(json['unit_id']),
      points: json['points'] != null 
          ? (json['points'] as List).map((e) => (e as List).map((p) => UnitData._toDouble(p) ?? 0.0).toList()).toList() 
          : null,
    );
  }
  Map<String, dynamic> toJson() => _$ShapeToJson(this);
}
