// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectsResponseModel _$ProjectsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProjectsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectsResponseModelToJson(
        ProjectsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : Media.fromJson(json['main_image'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'main_image': instance.mainImage,
      'media': instance.media,
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: (json['size'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'mime_type': instance.mimeType,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'page': instance.page,
    };
