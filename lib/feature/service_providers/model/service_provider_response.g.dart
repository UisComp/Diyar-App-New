// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProviderResponse _$ServiceProviderResponseFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServiceProviderResponseToJson(
        ServiceProviderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

IconModel _$IconModelFromJson(Map<String, dynamic> json) => IconModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$IconModelToJson(IconModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'uploaded_at': instance.uploadedAt,
    };

ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    ServiceProvider(
      id: (json['id'] as num?)?.toInt(),
      jobTitle: json['job_title'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      icon: json['icon'] == null
          ? null
          : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) =>
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
