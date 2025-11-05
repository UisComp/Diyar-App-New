// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_pass_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorPassResponse _$VisitorPassResponseFromJson(Map<String, dynamic> json) =>
    VisitorPassResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : VisitorPassData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VisitorPassResponseToJson(
        VisitorPassResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

VisitorPassData _$VisitorPassDataFromJson(Map<String, dynamic> json) =>
    VisitorPassData(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String?,
      visitorName: json['visitor_name'] as String?,
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String?,
      isOneTimeUse: json['is_one_time_use'] as bool?,
    );

Map<String, dynamic> _$VisitorPassDataToJson(VisitorPassData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'visitor_name': instance.visitorName,
      'unit': instance.unit,
      'valid_from': instance.validFrom,
      'valid_until': instance.validUntil,
      'is_one_time_use': instance.isOneTimeUse,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
