// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model_details_for_linked_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitModelDetailsForLinkedUserResponseModel
    _$UnitModelDetailsForLinkedUserResponseModelFromJson(
            Map<String, dynamic> json) =>
        UnitModelDetailsForLinkedUserResponseModel(
          success: json['success'] as bool?,
          message: json['message'] as String?,
          data: json['data'] == null
              ? null
              : UnitData.fromJson(json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UnitModelDetailsForLinkedUserResponseModelToJson(
        UnitModelDetailsForLinkedUserResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

UnitData _$UnitDataFromJson(Map<String, dynamic> json) => UnitData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      building: json['building'] as String?,
      number: json['number'] as String?,
      projectId: json['project_id'] as String?,
      userId: json['user_id'] as String?,
      unitValue: (json['unit_value'] as num?)?.toDouble(),
      downPayment: (json['down_payment'] as num?)?.toDouble(),
      interestRate: (json['interest_rate'] as num?)?.toDouble(),
      installmentCount: (json['installments_count'] as num?)?.toInt(),
      firstInstallmentDate: json['first_installment_date'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : Media.fromJson(json['main_image'] as Map<String, dynamic>),
      news: (json['news'] as List<dynamic>?)
          ?.map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitDataToJson(UnitData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'building': instance.building,
      'number': instance.number,
      'project_id': instance.projectId,
      'user_id': instance.userId,
      'unit_value': instance.unitValue,
      'down_payment': instance.downPayment,
      'interest_rate': instance.interestRate,
      'installments_count': instance.installmentCount,
      'first_installment_date': instance.firstInstallmentDate,
      'main_image': instance.mainImage?.toJson(),
      'news': instance.news?.map((e) => e.toJson()).toList(),
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: (json['size'] as num?)?.toInt(),
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'uploaded_at': instance.uploadedAt,
    };

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      newsDate: json['news_date'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      unit: json['unit'] == null
          ? null
          : UnitData.fromJson(json['unit'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'news_date': instance.newsDate,
      'media': instance.media?.map((e) => e.toJson()).toList(),
      'unit': instance.unit?.toJson(),
      'project': instance.project?.toJson(),
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : Media.fromJson(json['main_image'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasUnitMapping: json['has_unit_mapping'] as bool?,
      unitMapping: json['unit_mapping'] == null
          ? null
          : UnitMapping.fromJson(json['unit_mapping'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'main_image': instance.mainImage?.toJson(),
      'media': instance.media?.map((e) => e.toJson()).toList(),
      'has_unit_mapping': instance.hasUnitMapping,
      'unit_mapping': instance.unitMapping?.toJson(),
    };

UnitMapping _$UnitMappingFromJson(Map<String, dynamic> json) => UnitMapping(
      version: json['version'] as String?,
      imageWidth: (json['imageWidth'] as num?)?.toInt(),
      imageHeight: (json['imageHeight'] as num?)?.toInt(),
      shapes: (json['shapes'] as List<dynamic>?)
          ?.map((e) => Shape.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitMappingToJson(UnitMapping instance) =>
    <String, dynamic>{
      'version': instance.version,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'shapes': instance.shapes?.map((e) => e.toJson()).toList(),
    };

Shape _$ShapeFromJson(Map<String, dynamic> json) => Shape(
      id: json['id'] as String?,
      shapeType: json['shapeType'] as String?,
      unitId: (json['unitId'] as num?)?.toInt(),
      points: (json['points'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$ShapeToJson(Shape instance) => <String, dynamic>{
      'id': instance.id,
      'shapeType': instance.shapeType,
      'unitId': instance.unitId,
      'points': instance.points,
    };
