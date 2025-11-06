// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_service_provider_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateServiceProviderResponseModel _$CreateServiceProviderResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateServiceProviderResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceBookingData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateServiceProviderResponseModelToJson(
        CreateServiceProviderResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ServiceBookingData _$ServiceBookingDataFromJson(Map<String, dynamic> json) =>
    ServiceBookingData(
      id: (json['id'] as num?)?.toInt(),
      bookingDate: json['booking_date'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      serviceProvider: json['service_provider'] == null
          ? null
          : ServiceProvider.fromJson(
              json['service_provider'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServiceBookingDataToJson(ServiceBookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_date': instance.bookingDate,
      'status': instance.status,
      'notes': instance.notes,
      'service_provider': instance.serviceProvider,
    };

ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    ServiceProvider(
      id: (json['id'] as num?)?.toInt(),
      jobTitle: json['job_title'] as String?,
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'job_title': instance.jobTitle,
    };
