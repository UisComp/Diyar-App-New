// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsDetailsResponseModel _$NewsDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    NewsDetailsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : NewsDataDetails.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsDetailsResponseModelToJson(
        NewsDetailsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

NewsDataDetails _$NewsDataDetailsFromJson(Map<String, dynamic> json) =>
    NewsDataDetails(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      newsDate: json['news_date'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaForNewsDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsDataDetailsToJson(NewsDataDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'news_date': instance.newsDate,
      'media': instance.media,
      'unit': instance.unit,
      'project': instance.project,
    };

MediaForNewsDetails _$MediaForNewsDetailsFromJson(Map<String, dynamic> json) =>
    MediaForNewsDetails(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: MediaForNewsDetails._toInt(json['size']),
      mimeType: json['mime_type'] as String?,
    );

Map<String, dynamic> _$MediaForNewsDetailsToJson(
        MediaForNewsDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': MediaForNewsDetails._fromInt(instance.size),
      'mime_type': instance.mimeType,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      projectId: Unit._toInt(json['project_id']),
      userId: Unit._toInt(json['user_id']),
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'project_id': Unit._fromInt(instance.projectId),
      'user_id': Unit._fromInt(instance.userId),
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : MediaForNewsDetails.fromJson(
              json['main_image'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaForNewsDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'main_image': instance.mainImage,
      'media': instance.media,
    };
