import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'project_details_response_model.g.dart';

@JsonSerializable()
class ProjectDetailsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final ProjectData? data;

  const ProjectDetailsResponseModel({this.success, this.message, this.data});

  factory ProjectDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDetailsResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}
@JsonSerializable()
class ProjectData extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  @JsonKey(name: 'main_image')
  final ProjectMedia? mainImage;

  final List<ProjectMedia>? media;

  @JsonKey(name: 'has_unit_mapping')
  final bool? hasUnitMapping;

  @JsonKey(name: 'unit_mapping')
  final UnitMapping? unitMapping;

  const ProjectData({
    this.id,
    this.name,
    this.mainImage,
    this.media,
    this.description,
    this.hasUnitMapping,
    this.unitMapping,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDataToJson(this);

  @override
  List<Object?> get props =>
      [id, name, mainImage, media, description, hasUnitMapping, unitMapping];
}
@JsonSerializable()
class UnitMapping extends Equatable {
  final String? version;
  final int? imageWidth;
  final int? imageHeight;
  final List<Shape>? shapes;

  const UnitMapping({
    this.version,
    this.imageWidth,
    this.imageHeight,
    this.shapes,
  });

  factory UnitMapping.fromJson(Map<String, dynamic> json) =>
      _$UnitMappingFromJson(json);

  Map<String, dynamic> toJson() => _$UnitMappingToJson(this);

  @override
  List<Object?> get props => [version, imageWidth, imageHeight, shapes];
}
@JsonSerializable()
class Shape extends Equatable {
  final String? id;

  final String? shapeType;

  final int? unitId;

  final List<List<double>>? points;

  const Shape({
    this.id,
    this.shapeType,
    this.unitId,
    this.points,
  });

  factory Shape.fromJson(Map<String, dynamic> json) => _$ShapeFromJson(json);

  Map<String, dynamic> toJson() => _$ShapeToJson(this);

  @override
  List<Object?> get props => [id, shapeType, unitId, points];
}


@JsonSerializable()
class ProjectMedia extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final String? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  const ProjectMedia({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) =>
      _$ProjectMediaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectMediaToJson(this);

  @override
  List<Object?> get props => [id, name, fileName, url, size, mimeType];
}
