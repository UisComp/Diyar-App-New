// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponseModel _$NotificationResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : NotificationDataWrapper.fromJson(
              json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : MetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationResponseModelToJson(
        NotificationResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
      'meta': instance.meta?.toJson(),
    };

NotificationDataWrapper _$NotificationDataWrapperFromJson(
        Map<String, dynamic> json) =>
    NotificationDataWrapper(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadNotificationsCount:
          (json['unread_notifications_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationDataWrapperToJson(
        NotificationDataWrapper instance) =>
    <String, dynamic>{
      'notifications': instance.notifications?.map((e) => e.toJson()).toList(),
      'unread_notifications_count': instance.unreadNotificationsCount,
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'description': instance.description,
      'image': instance.image,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'image_url': instance.imageUrl,
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'page': instance.page,
    };
