// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentsResponseModel _$DocumentsResponseModelFromJson(
        Map<String, dynamic> json) =>
    DocumentsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DocumentsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DocumentsResponseModelToJson(
        DocumentsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

DocumentsData _$DocumentsDataFromJson(Map<String, dynamic> json) =>
    DocumentsData(
      engineeringStructure: json['engineering_structure'] == null
          ? null
          : DocumentFile.fromJson(
              json['engineering_structure'] as Map<String, dynamic>),
      contract: json['contract'] == null
          ? null
          : DocumentFile.fromJson(json['contract'] as Map<String, dynamic>),
      installmentsTable: json['installments_table'] == null
          ? null
          : DocumentFile.fromJson(
              json['installments_table'] as Map<String, dynamic>),
      otherDocuments: (json['other_documents'] as List<dynamic>?)
          ?.map((e) => DocumentFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocumentsDataToJson(DocumentsData instance) =>
    <String, dynamic>{
      'engineering_structure': instance.engineeringStructure?.toJson(),
      'contract': instance.contract?.toJson(),
      'installments_table': instance.installmentsTable?.toJson(),
      'other_documents':
          instance.otherDocuments?.map((e) => e.toJson()).toList(),
    };

DocumentFile _$DocumentFileFromJson(Map<String, dynamic> json) => DocumentFile(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      mimeType: json['mime_type'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$DocumentFileToJson(DocumentFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'size': instance.size,
      'mime_type': instance.mimeType,
      'uploaded_at': instance.uploadedAt,
    };
