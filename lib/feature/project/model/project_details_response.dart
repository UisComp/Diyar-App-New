import 'package:json_annotation/json_annotation.dart';
part 'project_details_response.g.dart';

@JsonSerializable()
class ProjectDetailsResponse {
  final bool ?success;
  final String? message;
  final ProjectDetails ?data;

  ProjectDetailsResponse({
     this.success,
     this.message,
     this.data,
  });

  factory ProjectDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDetailsResponseToJson(this);
}

@JsonSerializable()
class ProjectDetails {
  final int ?id;
  final String ?name;
  final String ?description;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'created_at')
  final String ?createdAt;

  @JsonKey(name: 'updated_at')
  final String ?updatedAt;

  final List<ProjectMedia> ?media;

  ProjectDetails({
     this.id,
     this.name,
     this.description,
    this.deletedAt,
     this.createdAt,
     this.updatedAt,
     this.media,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDetailsToJson(this);
}

@JsonSerializable()
class ProjectMedia {
  final int ?id;

  @JsonKey(name: 'model_type')
  final String ?modelType;

  @JsonKey(name: 'model_id')
  final int ?modelId;

  final String ?uuid;

  @JsonKey(name: 'collection_name')
  final String ?collectionName;

  final String ?name;

  @JsonKey(name: 'file_name')
  final String ?fileName;

  @JsonKey(name: 'mime_type')
  final String ?mimeType;

  final String ?disk;

  @JsonKey(name: 'conversions_disk')
  final String ?conversionsDisk;

  final int ?size;

  final List<dynamic> ?manipulations;

  @JsonKey(name: 'custom_properties')
  final List<dynamic>? customProperties;

  @JsonKey(name: 'generated_conversions')
  final List<dynamic> ?generatedConversions;

  @JsonKey(name: 'responsive_images')
  final List<dynamic>? responsiveImages;

  @JsonKey(name: 'order_column')
  final int ?orderColumn;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String ?updatedAt;

  @JsonKey(name: 'original_url')
  final String ?originalUrl;

  @JsonKey(name: 'preview_url')
  final String ?previewUrl;

  ProjectMedia({
     this.id,
     this.modelType,
     this.modelId,
     this.uuid,
     this.collectionName,
     this.name,
     this.fileName,
     this.mimeType,
     this.disk,
     this.conversionsDisk,
     this.size,
     this.manipulations,
     this.customProperties,
     this.generatedConversions,
     this.responsiveImages,
     this.orderColumn,
     this.createdAt,
     this.updatedAt,
     this.originalUrl,
     this.previewUrl,
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) =>
      _$ProjectMediaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectMediaToJson(this);
}
