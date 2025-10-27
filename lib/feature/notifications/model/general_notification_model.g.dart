// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralNotificationModel _$GeneralNotificationModelFromJson(
        Map<String, dynamic> json) =>
    GeneralNotificationModel(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : NotificationDataBody.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as List<dynamic>?,
    );

Map<String, dynamic> _$GeneralNotificationModelToJson(
        GeneralNotificationModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data?.toJson(),
      'error': instance.error,
    };

NotificationDataBody _$NotificationDataBodyFromJson(
        Map<String, dynamic> json) =>
    NotificationDataBody(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$NotificationDataBodyToJson(
        NotificationDataBody instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
