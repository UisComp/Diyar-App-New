// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_by_project_unit_event_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewByProjectUnitEventResponseModel _$NewByProjectUnitEventResponseModelFromJson(
        Map<String, dynamic> json) =>
    NewByProjectUnitEventResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              NewsDataForUnitByProject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewByProjectUnitEventResponseModelToJson(
        NewByProjectUnitEventResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

NewsDataForUnitByProject _$NewsDataForUnitByProjectFromJson(
        Map<String, dynamic> json) =>
    NewsDataForUnitByProject(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      newsDate: json['newsDate'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaForNewsByProjectUnitEvent.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsDataForUnitByProjectToJson(
        NewsDataForUnitByProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'newsDate': instance.newsDate,
      'media': instance.media?.map((e) => e.toJson()).toList(),
      'unit': instance.unit?.toJson(),
      'project': instance.project?.toJson(),
    };

MediaForNewsByProjectUnitEvent _$MediaForNewsByProjectUnitEventFromJson(
        Map<String, dynamic> json) =>
    MediaForNewsByProjectUnitEvent(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['fileName'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      mimeType: json['mimeType'] as String?,
    );

Map<String, dynamic> _$MediaForNewsByProjectUnitEventToJson(
        MediaForNewsByProjectUnitEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fileName': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'mimeType': instance.mimeType,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      projectId: json['projectId'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'projectId': instance.projectId,
      'userId': instance.userId,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mainImage: json['mainImage'] == null
          ? null
          : MediaForNewsByProjectUnitEvent.fromJson(
              json['mainImage'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaForNewsByProjectUnitEvent.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mainImage': instance.mainImage?.toJson(),
      'media': instance.media?.map((e) => e.toJson()).toList(),
    };
