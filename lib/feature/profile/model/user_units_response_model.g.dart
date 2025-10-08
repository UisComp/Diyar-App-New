// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_units_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUnitsResponseModel _$UserUnitsResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserUnitsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserUnitsResponseModelToJson(
        UserUnitsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

UserUnit _$UserUnitFromJson(Map<String, dynamic> json) => UserUnit(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      projectId: (json['project_id'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] == null
          ? null
          : ProfilePicture.fromJson(json['imageUrl'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserUnitToJson(UserUnit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'user_id': instance.userId,
      'project_id': instance.projectId,
    };
