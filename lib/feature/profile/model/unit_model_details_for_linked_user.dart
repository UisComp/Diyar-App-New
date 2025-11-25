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

  factory UnitData.fromJson(Map<String, dynamic> json) =>
      _$UnitDataFromJson(json);
  Map<String, dynamic> toJson() => _$UnitDataToJson(this);
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

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
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

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
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

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnitMapping {
  final String? version;
  final int? imageWidth;
  final int? imageHeight;
  final List<Shape>? shapes;

  UnitMapping({this.version, this.imageWidth, this.imageHeight, this.shapes});

  factory UnitMapping.fromJson(Map<String, dynamic> json) =>
      _$UnitMappingFromJson(json);
  Map<String, dynamic> toJson() => _$UnitMappingToJson(this);
}

@JsonSerializable()
class Shape {
  final String? id;
  final String? shapeType;
  final int? unitId;
  final List<List<double>>? points;

  Shape({this.id, this.shapeType, this.unitId, this.points});

  factory Shape.fromJson(Map<String, dynamic> json) => _$ShapeFromJson(json);
  Map<String, dynamic> toJson() => _$ShapeToJson(this);
}
