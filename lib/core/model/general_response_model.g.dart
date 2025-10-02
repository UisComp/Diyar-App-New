// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponseModel _$GeneralResponseModelFromJson(
        Map<String, dynamic> json) =>
    GeneralResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$GeneralResponseModelToJson(
        GeneralResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
