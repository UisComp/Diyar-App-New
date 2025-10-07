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
    );

Map<String, dynamic> _$ProjectDataToJson(ProjectData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'main_image': instance.mainImage,
      'media': instance.media,
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
