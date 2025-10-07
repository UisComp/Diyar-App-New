import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news_details_response_model.g.dart';

@JsonSerializable()
class NewsDetailsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final NewsDataDetails? data;

  const NewsDetailsResponseModel({this.success, this.message, this.data});

  factory NewsDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsDetailsResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable()
class NewsDataDetails extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  @JsonKey(name: 'news_date')
  final String? newsDate;
  final List<MediaForNewsDetails>? media;
  final Unit? unit;
  final Project? project;

  const NewsDataDetails({
    this.id,
    this.title,
    this.content,
    this.newsDate,
    this.media,
    this.unit,
    this.project,
  });

  factory NewsDataDetails.fromJson(Map<String, dynamic> json) =>
      _$NewsDataDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsDataDetailsToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    newsDate,
    media,
    unit,
    project,
  ];
}

@JsonSerializable()
class MediaForNewsDetails extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  final int? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  const MediaForNewsDetails({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory MediaForNewsDetails.fromJson(Map<String, dynamic> json) =>
      _$MediaForNewsDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MediaForNewsDetailsToJson(this);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static dynamic _fromInt(int? value) => value;

  @override
  List<Object?> get props => [id, name, fileName, url, size, mimeType];
}

@JsonSerializable()
class Unit extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'project_id', fromJson: _toInt, toJson: _fromInt)
  final int? projectId;
  @JsonKey(name: 'user_id', fromJson: _toInt, toJson: _fromInt)
  final int? userId;

  const Unit({this.id, this.name, this.projectId, this.userId});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static dynamic _fromInt(int? value) => value;

  @override
  List<Object?> get props => [id, name, projectId, userId];
}

@JsonSerializable()
class Project extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'main_image')
  final MediaForNewsDetails? mainImage;
  final List<MediaForNewsDetails>? media;

  const Project({this.id, this.name, this.mainImage, this.media});

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  @override
  List<Object?> get props => [id, name, mainImage, media];
}
