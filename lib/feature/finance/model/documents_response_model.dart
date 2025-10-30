import 'package:json_annotation/json_annotation.dart';

part 'documents_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentsResponseModel {
  final bool? success;
  final String? message;
  final DocumentsData? data;

  DocumentsResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory DocumentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DocumentsData {
  @JsonKey(name: "engineering_structure")
  final DocumentFile? engineeringStructure;

  final DocumentFile? contract;

  @JsonKey(name: "installments_table")
  final DocumentFile? installmentsTable;

  @JsonKey(name: "other_documents")
  final List<DocumentFile>? otherDocuments;

  DocumentsData({
    this.engineeringStructure,
    this.contract,
    this.installmentsTable,
    this.otherDocuments,
  });

  factory DocumentsData.fromJson(Map<String, dynamic> json) =>
      _$DocumentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentsDataToJson(this);
}

@JsonSerializable()
class DocumentFile {
  final int? id;
  final String? name;
  final String? url;
  final String? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  DocumentFile({
    this.id,
    this.name,
    this.url,
    this.size,
    this.mimeType,
    this.uploadedAt,
  });

  factory DocumentFile.fromJson(Map<String, dynamic> json) =>
      _$DocumentFileFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentFileToJson(this);
}
