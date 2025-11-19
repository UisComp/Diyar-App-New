// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDetailsResponseModel _$ProjectDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProjectDetailsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProjectData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectDetailsResponseModelToJson(
        ProjectDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ProjectData _$ProjectDataFromJson(Map<String, dynamic> json) => ProjectData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : ProjectMedia.fromJson(json['main_image'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => ProjectMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      hasUnitMapping: json['has_unit_mapping'] as bool?,
      unitMapping: json['unit_mapping'] == null
          ? null
          : UnitMapping.fromJson(json['unit_mapping'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectDataToJson(ProjectData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'main_image': instance.mainImage,
      'media': instance.media,
      'has_unit_mapping': instance.hasUnitMapping,
      'unit_mapping': instance.unitMapping,
    };

UnitMapping _$UnitMappingFromJson(Map<String, dynamic> json) => UnitMapping(
      version: json['version'] as String?,
      imageWidth: (json['imageWidth'] as num?)?.toInt(),
      imageHeight: (json['imageHeight'] as num?)?.toInt(),
      shapes: (json['shapes'] as List<dynamic>?)
          ?.map((e) => Shape.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitMappingToJson(UnitMapping instance) =>
    <String, dynamic>{
      'version': instance.version,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'shapes': instance.shapes,
    };

Shape _$ShapeFromJson(Map<String, dynamic> json) => Shape(
      id: json['id'] as String?,
      shapeType: json['shapeType'] as String?,
      unitId: (json['unitId'] as num?)?.toInt(),
      points: (json['points'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$ShapeToJson(Shape instance) => <String, dynamic>{
      'id': instance.id,
      'shapeType': instance.shapeType,
      'unitId': instance.unitId,
      'points': instance.points,
    };

ProjectMedia _$ProjectMediaFromJson(Map<String, dynamic> json) => ProjectMedia(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      mimeType: json['mime_type'] as String?,
    );

Map<String, dynamic> _$ProjectMediaToJson(ProjectMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'mime_type': instance.mimeType,
    };
