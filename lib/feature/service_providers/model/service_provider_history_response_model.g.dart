// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProviderHistoryResponseModel
    _$ServiceProviderHistoryResponseModelFromJson(Map<String, dynamic> json) =>
        ServiceProviderHistoryResponseModel(
          success: json['success'] as bool?,
          message: json['message'] as String?,
          data: (json['data'] as List<dynamic>?)
              ?.map((e) => ServiceProviderBookingModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ServiceProviderHistoryResponseModelToJson(
        ServiceProviderHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ServiceProviderBookingModel _$ServiceProviderBookingModelFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderBookingModel(
      id: (json['id'] as num?)?.toInt(),
      bookingDate: json['booking_date'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      serviceProvider: json['service_provider'] == null
          ? null
          : ServiceProviderModel.fromJson(
              json['service_provider'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ServiceProviderBookingModelToJson(
        ServiceProviderBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_date': instance.bookingDate,
      'status': instance.status,
      'notes': instance.notes,
      'service_provider': instance.serviceProvider,
      'user': instance.user,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ServiceProviderModel _$ServiceProviderModelFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderModel(
      id: (json['id'] as num?)?.toInt(),
      jobTitle: json['job_title'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      icon: json['icon'] == null
          ? null
          : ServiceProviderIconModel.fromJson(
              json['icon'] as Map<String, dynamic>),
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ServiceProviderModelToJson(
        ServiceProviderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'job_title': instance.jobTitle,
      'description': instance.description,
      'is_active': instance.isActive,
      'icon': instance.icon,
      'icon_url': instance.iconUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ServiceProviderIconModel _$ServiceProviderIconModelFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderIconModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$ServiceProviderIconModelToJson(
        ServiceProviderIconModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'uploaded_at': instance.uploadedAt,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
