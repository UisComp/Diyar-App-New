// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDetailsResponse _$ProjectDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    ProjectDetailsResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProjectDetails.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectDetailsResponseToJson(
        ProjectDetailsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ProjectDetails _$ProjectDetailsFromJson(Map<String, dynamic> json) =>
    ProjectDetails(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => ProjectMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectDetailsToJson(ProjectDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'deleted_at': instance.deletedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'media': instance.media,
    };

ProjectMedia _$ProjectMediaFromJson(Map<String, dynamic> json) => ProjectMedia(
      id: (json['id'] as num?)?.toInt(),
      modelType: json['model_type'] as String?,
      modelId: (json['model_id'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      collectionName: json['collection_name'] as String?,
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      mimeType: json['mime_type'] as String?,
      disk: json['disk'] as String?,
      conversionsDisk: json['conversions_disk'] as String?,
      size: (json['size'] as num?)?.toInt(),
      manipulations: json['manipulations'] as List<dynamic>?,
      customProperties: json['custom_properties'] as List<dynamic>?,
      generatedConversions: json['generated_conversions'] as List<dynamic>?,
      responsiveImages: json['responsive_images'] as List<dynamic>?,
      orderColumn: (json['order_column'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      originalUrl: json['original_url'] as String?,
      previewUrl: json['preview_url'] as String?,
    );

Map<String, dynamic> _$ProjectMediaToJson(ProjectMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'model_type': instance.modelType,
      'model_id': instance.modelId,
      'uuid': instance.uuid,
      'collection_name': instance.collectionName,
      'name': instance.name,
      'file_name': instance.fileName,
      'mime_type': instance.mimeType,
      'disk': instance.disk,
      'conversions_disk': instance.conversionsDisk,
      'size': instance.size,
      'manipulations': instance.manipulations,
      'custom_properties': instance.customProperties,
      'generated_conversions': instance.generatedConversions,
      'responsive_images': instance.responsiveImages,
      'order_column': instance.orderColumn,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'original_url': instance.originalUrl,
      'preview_url': instance.previewUrl,
    };
