// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_or_forget_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetOrForgetPasswordResponseModel _$ResetOrForgetPasswordResponseModelFromJson(
        Map<String, dynamic> json) =>
    ResetOrForgetPasswordResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ResetOrForgetPasswordResponseModelToJson(
        ResetOrForgetPasswordResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
