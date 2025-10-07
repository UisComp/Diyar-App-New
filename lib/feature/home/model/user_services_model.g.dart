// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserServicesResponse _$UserServicesResponseFromJson(
        Map<String, dynamic> json) =>
    UserServicesResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserServiceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserServicesResponseToJson(
        UserServicesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

UserServiceData _$UserServiceDataFromJson(Map<String, dynamic> json) =>
    UserServiceData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: (json['type'] as num?)?.toInt(),
      icon: json['icon'] == null
          ? null
          : IconDataModel.fromJson(json['icon'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserServiceDataToJson(UserServiceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
      'roles': instance.roles?.map((e) => e.toJson()).toList(),
      'type': instance.type,
      'icon': instance.icon?.toJson(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

IconDataModel _$IconDataModelFromJson(Map<String, dynamic> json) =>
    IconDataModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      mimeType: json['mime_type'] as String?,
    );

Map<String, dynamic> _$IconDataModelToJson(IconDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'mime_type': instance.mimeType,
    };
