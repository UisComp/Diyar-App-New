import 'package:json_annotation/json_annotation.dart';

part 'announcements_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnnouncementsResponseModel {
  final bool? success;
  final String? message;
  final List<Announcement>? data;

  AnnouncementsResponseModel({this.success, this.message, this.data});

  factory AnnouncementsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementsResponseModelToJson(this);
}

@JsonSerializable()
class Announcement {
  final int? id;
  final String? title;
  final String? description;

  /// Full-size image. The API sends `""` when there's none; read [imageUrl].
  final String? url;

  /// Standard watch link, `https://www.youtube.com/watch?v=<id>`. The API
  /// sends `""` when there's no video; read [youtubeUrl].
  @JsonKey(name: 'youtube_url')
  final String? rawYoutubeUrl;

  /// The 11-character YouTube video id, or `""`; read [youtubeVideoId].
  @JsonKey(name: 'youtube_video_id')
  final String? rawYoutubeVideoId;

  Announcement({
    this.id,
    this.title,
    this.description,
    this.url,
    this.rawYoutubeUrl,
    this.rawYoutubeVideoId,
  });

  String? get imageUrl => _nonEmpty(url);
  String? get youtubeUrl => _nonEmpty(rawYoutubeUrl);
  String? get youtubeVideoId => _nonEmpty(rawYoutubeVideoId);
  bool get hasImage => imageUrl != null;
  bool get hasVideo => youtubeVideoId != null && youtubeUrl != null;

  /// YouTube's own thumbnail. `hqdefault` exists for every video, unlike
  /// `maxresdefault`.
  String? get youtubeThumbnailUrl => hasVideo
      ? 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg'
      : null;

  /// What to show before the player loads: the announcement's own image when
  /// there is one, otherwise YouTube's thumbnail.
  String? get posterUrl => imageUrl ?? youtubeThumbnailUrl;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}

String? _nonEmpty(String? value) =>
    value != null && value.trim().isNotEmpty ? value.trim() : null;
