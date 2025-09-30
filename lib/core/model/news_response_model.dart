import 'package:json_annotation/json_annotation.dart';
part 'news_response_model.g.dart';

@JsonSerializable()
class NewsResponseModel {
  final bool? success;
  final String? message;
  final List<NewsData>? data;
  final Meta? meta;
  NewsResponseModel({this.success, this.message, this.data, this.meta});
  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseModelToJson(this);
}

//---

@JsonSerializable()
class NewsData {
  final int? id;
  final String? title;
  final String? content;
  @JsonKey(name: 'news_date')
  final DateTime? newsDate;
  final List<Media>? media;
  final Unit? unit;
  final Project? project;

  NewsData({
    this.id,
    this.title,
    this.content,
    this.newsDate,
    this.media,
    this.unit,
    this.project,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) =>
      _$NewsDataFromJson(json);
  Map<String, dynamic> toJson() => _$NewsDataToJson(this);
}

//---

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
class Unit {
  final int? id;
  final String? name;

  Unit({this.id, this.name});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
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
class Meta {
  final int? limit;
  final int? total;

  @JsonKey(name: 'totalPages')
  final int? totalPages;

  final int? page;

  Meta({this.limit, this.total, this.totalPages, this.page});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
