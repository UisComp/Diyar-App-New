// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigResponseModel _$ConfigResponseModelFromJson(Map<String, dynamic> json) =>
    ConfigResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ConfigData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigResponseModelToJson(
        ConfigResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

ConfigData _$ConfigDataFromJson(Map<String, dynamic> json) => ConfigData(
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      emergencyNumber: json['emergency_number'] as String?,
    );

Map<String, dynamic> _$ConfigDataToJson(ConfigData instance) =>
    <String, dynamic>{
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'emergency_number': instance.emergencyNumber,
    };
