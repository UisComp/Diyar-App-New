import 'package:json_annotation/json_annotation.dart';
part 'projects_response_model.g.dart';

@JsonSerializable()
class ProjectsResponseModel {
  final bool? success;
  final String? message;
  final List<Project>? data;
  final Meta? meta;

  ProjectsResponseModel({this.success, this.message, this.data, this.meta});

  factory ProjectsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectsResponseModelToJson(this);
}

@JsonSerializable()
class Project {
  final int? id;
  final String? name;
  @JsonKey(name: 'main_image')
  final Media? mainImage;
  final List<Media>? media;

  Project({this.id, this.name, this.mainImage, this.media});

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable()
class Media {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final int? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  Media({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable()
class Meta {
  final int? limit;
  final int? total;
  final int? totalPages;
  final int? page;

  Meta({this.limit, this.total, this.totalPages, this.page});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
