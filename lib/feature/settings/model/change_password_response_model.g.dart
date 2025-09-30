// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponseModel _$ChangePasswordResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ChangePasswordResponseModelToJson(
        ChangePasswordResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
