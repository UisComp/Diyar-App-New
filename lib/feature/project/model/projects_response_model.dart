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

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: _toInt(json['id']),
      name: json['name'] as String?,
      mainImage: json['main_image'] == null
          ? null
          : Media.fromJson(json['main_image'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

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

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: _toInt(json['id']),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: _toInt(json['size']),
      mimeType: json['mime_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable()
class Meta {
  final int? limit;
  final int? total;
  final int? totalPages;
  final int? page;

  Meta({this.limit, this.total, this.totalPages, this.page});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      limit: _toInt(json['limit']),
      total: _toInt(json['total']),
      totalPages: _toInt(json['totalPages']),
      page: _toInt(json['page']),
    );
  }

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
