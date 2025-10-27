// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageData _$MessageDataFromJson(Map<String, dynamic> json) => MessageData(
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MessageDataToJson(MessageData instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
    };
