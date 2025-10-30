import 'package:json_annotation/json_annotation.dart';

part 'announcements_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnnouncementsResponseModel {
  final bool? success;
  final String? message;
  final List<Announcement>? data;

  AnnouncementsResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory AnnouncementsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementsResponseModelToJson(this);
}

@JsonSerializable()
class Announcement {
  final int? id;
  final String? title;
  final String? description;
  final String? url;

  Announcement({
    this.id,
    this.title,
    this.description,
    this.url,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
