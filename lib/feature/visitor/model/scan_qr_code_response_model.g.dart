// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_qr_code_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanQrCodeResponseModel _$ScanQrCodeResponseModelFromJson(
        Map<String, dynamic> json) =>
    ScanQrCodeResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ScanQrCodeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScanQrCodeResponseModelToJson(
        ScanQrCodeResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ScanQrCodeData _$ScanQrCodeDataFromJson(Map<String, dynamic> json) =>
    ScanQrCodeData(
      valid: json['valid'] as bool?,
      visitorName: json['visitor_name'] as String?,
      visitorPhone: json['visitor_phone'] as String?,
      visitorVehicle: json['visitor_vehicle'] as String?,
      purpose: json['purpose'] as String?,
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      validUntil: json['valid_until'] as String?,
      firstScan: json['first_scan'] as bool?,
      scanCount: json['scan_count'] as String?,
      isOneTimeUse: json['is_one_time_use'] as bool?,
    );

Map<String, dynamic> _$ScanQrCodeDataToJson(ScanQrCodeData instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'visitor_name': instance.visitorName,
      'visitor_phone': instance.visitorPhone,
      'visitor_vehicle': instance.visitorVehicle,
      'purpose': instance.purpose,
      'unit': instance.unit,
      'owner': instance.owner,
      'valid_until': instance.validUntil,
      'first_scan': instance.firstScan,
      'scan_count': instance.scanCount,
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

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
    };
