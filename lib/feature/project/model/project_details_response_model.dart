import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'project_details_response_model.g.dart';

@JsonSerializable()
class ProjectDetailsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final ProjectData? data;

  const ProjectDetailsResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProjectDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDetailsResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable()
class ProjectData extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'main_image')
  final ProjectMedia? mainImage;
  final List<ProjectMedia>? media;

  const ProjectData({
    this.id,
    this.name,
    this.mainImage,
    this.media,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDataToJson(this);

  @override
  List<Object?> get props => [id, name, mainImage, media];
}

@JsonSerializable()
class ProjectMedia extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final String? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  const ProjectMedia({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) =>
      _$ProjectMediaFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectMediaToJson(this);

  @override
  List<Object?> get props => [id, name, fileName, url, size, mimeType];
}
