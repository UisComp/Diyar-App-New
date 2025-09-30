// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResponseModel _$NewsResponseModelFromJson(Map<String, dynamic> json) =>
    NewsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NewsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsResponseModelToJson(NewsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

NewsData _$NewsDataFromJson(Map<String, dynamic> json) => NewsData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      newsDate: json['news_date'] == null
          ? null
          : DateTime.parse(json['news_date'] as String),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsDataToJson(NewsData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'news_date': instance.newsDate?.toIso8601String(),
      'media': instance.media,
      'unit': instance.unit,
      'project': instance.project,
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

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
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
