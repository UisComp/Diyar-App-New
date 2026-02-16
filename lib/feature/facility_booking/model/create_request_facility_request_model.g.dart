// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_request_facility_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRequestFacilityRequestModel _$CreateRequestFacilityRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateRequestFacilityRequestModel(
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => FacilityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateRequestFacilityRequestModelToJson(
        CreateRequestFacilityRequestModel instance) =>
    <String, dynamic>{
      'facilities': instance.facilities,
    };

FacilityItem _$FacilityItemFromJson(Map<String, dynamic> json) => FacilityItem(
      id: (json['id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      bookingDate: json['booking_date'] as String?,
    );

Map<String, dynamic> _$FacilityItemToJson(FacilityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'booking_date': instance.bookingDate,
    };
