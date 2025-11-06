// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_request_facility_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRequestFacilityResponseModel _$CreateRequestFacilityResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateRequestFacilityResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RequestFacilityData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateRequestFacilityResponseModelToJson(
        CreateRequestFacilityResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

RequestFacilityData _$RequestFacilityDataFromJson(Map<String, dynamic> json) =>
    RequestFacilityData(
      id: (json['id'] as num?)?.toInt(),
      bookingDate: json['booking_date'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      facility: json['facility'] == null
          ? null
          : Facility.fromJson(json['facility'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestFacilityDataToJson(
        RequestFacilityData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_date': instance.bookingDate,
      'status': instance.status,
      'notes': instance.notes,
      'facility': instance.facility,
    };

Facility _$FacilityFromJson(Map<String, dynamic> json) => Facility(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$FacilityToJson(Facility instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
