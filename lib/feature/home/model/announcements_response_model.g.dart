// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementsResponseModel _$AnnouncementsResponseModelFromJson(
        Map<String, dynamic> json) =>
    AnnouncementsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnnouncementsResponseModelToJson(
        AnnouncementsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      rawYoutubeUrl: json['youtube_url'] as String?,
      rawYoutubeVideoId: json['youtube_video_id'] as String?,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'youtube_url': instance.rawYoutubeUrl,
      'youtube_video_id': instance.rawYoutubeVideoId,
    };
