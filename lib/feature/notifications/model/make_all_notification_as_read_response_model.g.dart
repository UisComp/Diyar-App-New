// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_all_notification_as_read_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeAllNotificationAsReadResponseModel
    _$MakeAllNotificationAsReadResponseModelFromJson(
            Map<String, dynamic> json) =>
        MakeAllNotificationAsReadResponseModel(
          status: json['status'] as bool,
          data: json['data'] == null
              ? null
              : MakeAllNotificationAsReadData.fromJson(
                  json['data'] as Map<String, dynamic>),
          error: (json['error'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$MakeAllNotificationAsReadResponseModelToJson(
        MakeAllNotificationAsReadResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data?.toJson(),
      'error': instance.error,
    };

MakeAllNotificationAsReadData _$MakeAllNotificationAsReadDataFromJson(
        Map<String, dynamic> json) =>
    MakeAllNotificationAsReadData(
      message: json['message'] as String,
    );

Map<String, dynamic> _$MakeAllNotificationAsReadDataToJson(
        MakeAllNotificationAsReadData instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
