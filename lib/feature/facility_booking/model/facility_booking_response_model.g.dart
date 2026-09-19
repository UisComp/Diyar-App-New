// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_booking_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityResponse _$FacilityResponseFromJson(Map<String, dynamic> json) =>
    FacilityResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Facility.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FacilityResponseToJson(FacilityResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

Facility _$FacilityFromJson(Map<String, dynamic> json) => Facility(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$BookableStatusEnumMap, json['status'],
              unknownValue: BookableStatus.unknown) ??
          BookableStatus.unknown,
      isActive: json['is_active'] as bool?,
      isBookable: json['is_bookable'] as bool? ?? false,
      icon: json['icon'] == null
          ? null
          : FacilityIcon.fromJson(json['icon'] as Map<String, dynamic>),
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FacilityToJson(Facility instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$BookableStatusEnumMap[instance.status]!,
      'is_active': instance.isActive,
      'is_bookable': instance.isBookable,
      'icon': instance.icon,
      'icon_url': instance.iconUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$BookableStatusEnumMap = {
  BookableStatus.active: 'active',
  BookableStatus.bookingClosed: 'booking_closed',
  BookableStatus.hidden: 'hidden',
  BookableStatus.unknown: 'unknown',
};

FacilityIcon _$FacilityIconFromJson(Map<String, dynamic> json) => FacilityIcon(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: _sizeFromJson(json['size']),
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$FacilityIconToJson(FacilityIcon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': _sizeToJson(instance.size),
      'uploaded_at': instance.uploadedAt,
    };
