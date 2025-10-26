// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_booking_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityModel _$FacilityModelFromJson(Map<String, dynamic> json) =>
    FacilityModel(
      url: json['url'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$FacilityModelToJson(FacilityModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
    };
