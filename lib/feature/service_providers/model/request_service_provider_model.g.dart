// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_service_provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestServiceProviderModel _$RequestServiceProviderModelFromJson(
        Map<String, dynamic> json) =>
    RequestServiceProviderModel(
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingDate: json['booking_date'] as String?,
    );

Map<String, dynamic> _$RequestServiceProviderModelToJson(
        RequestServiceProviderModel instance) =>
    <String, dynamic>{
      'services': instance.services,
      'booking_date': instance.bookingDate,
    };

ServiceItem _$ServiceItemFromJson(Map<String, dynamic> json) => ServiceItem(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ServiceItemToJson(ServiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
