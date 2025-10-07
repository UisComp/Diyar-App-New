import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<AllNewsData>? data;
  final Meta? meta;

  const NewsResponseModel({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseModelToJson(this);

  NewsResponseModel copyWith({
    bool? success,
    String? message,
    List<AllNewsData>? data,
    Meta? meta,
  }) {
    return NewsResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object?> get props => [success, message, data, meta];
}

@JsonSerializable(explicitToJson: true)
class AllNewsData extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  @JsonKey(name: 'news_date')
  final String? newsDate;
  final List<MediaForAllNews>? media;
  final Unit? unit;
  final Project? project;

  const AllNewsData({
    this.id,
    this.title,
    this.content,
    this.newsDate,
    this.media,
    this.unit,
    this.project,
  });

  factory AllNewsData.fromJson(Map<String, dynamic> json) =>
      _$AllNewsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllNewsDataToJson(this);

  AllNewsData copyWith({
    int? id,
    String? title,
    String? content,
    String? newsDate,
    List<MediaForAllNews>? media,
    Unit? unit,
    Project? project,
  }) {
    return AllNewsData(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      newsDate: newsDate ?? this.newsDate,
      media: media ?? this.media,
      unit: unit ?? this.unit,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [id, title, content, newsDate, media, unit, project];
}

@JsonSerializable()
class MediaForAllNews extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final String? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  const MediaForAllNews({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory MediaForAllNews.fromJson(Map<String, dynamic> json) => _$MediaForAllNewsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaForAllNewsToJson(this);

  MediaForAllNews copyWith({
    int? id,
    String? name,
    String? fileName,
    String? url,
    String? size,
    String? mimeType,
  }) {
    return MediaForAllNews(
      id: id ?? this.id,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  List<Object?> get props => [id, name, fileName, url, size, mimeType];
}

@JsonSerializable()
class Unit extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'project_id')
  final String? projectId;
  @JsonKey(name: 'user_id')
  final String? userId;

  const Unit({
    this.id,
    this.name,
    this.projectId,
    this.userId,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  Unit copyWith({
    int? id,
    String? name,
    String? projectId,
    String? userId,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, name, projectId, userId];
}

@JsonSerializable(explicitToJson: true)
class Project extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'main_image')
  final MediaForAllNews? mainImage;
  final List<MediaForAllNews>? media;

  const Project({
    this.id,
    this.name,
    this.mainImage,
    this.media,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  Project copyWith({
    int? id,
    String? name,
    MediaForAllNews? mainImage,
    List<MediaForAllNews>? media,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      mainImage: mainImage ?? this.mainImage,
      media: media ?? this.media,
    );
  }

  @override
  List<Object?> get props => [id, name, mainImage, media];
}

@JsonSerializable()
class Meta extends Equatable {
  final int? limit;
  final int? total;
  final int? totalPages;
  final int? page;

  const Meta({
    this.limit,
    this.total,
    this.totalPages,
    this.page,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);

  Meta copyWith({
    int? limit,
    int? total,
    int? totalPages,
    int? page,
  }) {
    return Meta(
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [limit, total, totalPages, page];
}
