import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news_by_project_unit_event_response_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class NewByProjectUnitEventResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<NewsDataForUnitByProject>? data;

  const NewByProjectUnitEventResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory NewByProjectUnitEventResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$NewByProjectUnitEventResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NewByProjectUnitEventResponseModelToJson(this);

  NewByProjectUnitEventResponseModel copyWith({
    bool? success,
    String? message,
    List<NewsDataForUnitByProject>? data,
  }) {
    return NewByProjectUnitEventResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class NewsDataForUnitByProject extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final String? newsDate;
  final List<MediaForNewsByProjectUnitEvent>? media;
  final Unit? unit;
  final Project? project;

  const NewsDataForUnitByProject({
    this.id,
    this.title,
    this.content,
    this.newsDate,
    this.media,
    this.unit,
    this.project,
  });

  factory NewsDataForUnitByProject.fromJson(Map<String, dynamic> json) =>
      _$NewsDataForUnitByProjectFromJson(json);

  Map<String, dynamic> toJson() => _$NewsDataForUnitByProjectToJson(this);

  NewsDataForUnitByProject copyWith({
    int? id,
    String? title,
    String? content,
    String? newsDate,
    List<MediaForNewsByProjectUnitEvent>? media,
    Unit? unit,
    Project? project,
  }) {
    return NewsDataForUnitByProject(
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

@JsonSerializable(includeIfNull: true)
class MediaForNewsByProjectUnitEvent extends Equatable {
  final int? id;
  final String? name;
  final String? fileName;
  final String? url;
  final String? size;
  final String? mimeType;

  const MediaForNewsByProjectUnitEvent({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory MediaForNewsByProjectUnitEvent.fromJson(Map<String, dynamic> json) =>
      _$MediaForNewsByProjectUnitEventFromJson(json);
  Map<String, dynamic> toJson() => _$MediaForNewsByProjectUnitEventToJson(this);

  MediaForNewsByProjectUnitEvent copyWith({
    int? id,
    String? name,
    String? fileName,
    String? url,
    String? size,
    String? mimeType,
  }) {
    return MediaForNewsByProjectUnitEvent(
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

@JsonSerializable(includeIfNull: true)
class Unit extends Equatable {
  final int? id;
  final String? name;
  final String? projectId;
  final String? userId;

  const Unit({this.id, this.name, this.projectId, this.userId});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);

  Unit copyWith({int? id, String? name, String? projectId, String? userId}) {
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

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Project extends Equatable {
  final int? id;
  final String? name;
  final MediaForNewsByProjectUnitEvent? mainImage;
  final List<MediaForNewsByProjectUnitEvent>? media;

  const Project({this.id, this.name, this.mainImage, this.media});

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  Project copyWith({
    int? id,
    String? name,
    MediaForNewsByProjectUnitEvent? mainImage,
    List<MediaForNewsByProjectUnitEvent>? media,
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
