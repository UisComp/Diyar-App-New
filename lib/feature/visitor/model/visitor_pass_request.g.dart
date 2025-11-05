// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_pass_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorPassRequest _$VisitorPassRequestFromJson(Map<String, dynamic> json) =>
    VisitorPassRequest(
      unitId: (json['unit_id'] as num?)?.toInt(),
      visitorName: json['visitor_name'] as String?,
      visitorPhone: json['visitor_phone'] as String?,
      visitorVehicle: json['visitor_vehicle'] as String?,
      purpose: json['purpose'] as String?,
      startDate: json['start_date'] as String?,
      startTime: json['start_time'] as String?,
      endDate: json['end_date'] as String?,
      endTime: json['end_time'] as String?,
      isOneTimeUse: json['is_one_time_use'] as bool?,
    );

Map<String, dynamic> _$VisitorPassRequestToJson(VisitorPassRequest instance) =>
    <String, dynamic>{
      'unit_id': instance.unitId,
      'visitor_name': instance.visitorName,
      'visitor_phone': instance.visitorPhone,
      'visitor_vehicle': instance.visitorVehicle,
      'purpose': instance.purpose,
      'start_date': instance.startDate,
      'start_time': instance.startTime,
      'end_date': instance.endDate,
      'end_time': instance.endTime,
      'is_one_time_use': instance.isOneTimeUse,
    };
