// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_request_facility_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRequestFacilityRequestModel _$CreateRequestFacilityRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateRequestFacilityRequestModel(
      facilityIds: (json['facility_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      bookingDate: json['booking_date'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreateRequestFacilityRequestModelToJson(
        CreateRequestFacilityRequestModel instance) =>
    <String, dynamic>{
      'facility_ids': instance.facilityIds,
      'booking_date': instance.bookingDate,
      'notes': instance.notes,
    };
