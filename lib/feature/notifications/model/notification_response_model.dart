import 'package:json_annotation/json_annotation.dart';
part 'notification_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationResponseModel {
  final bool? status;
  final List<NotificationData>? data;

  @JsonKey(name: 'error')
  final List<dynamic>? error;

  @JsonKey(name: 'unread_notifications_count')
  final int? unreadNotificationsCount;

  NotificationResponseModel({
    this.status,
    this.data,
    this.error,
    this.unreadNotificationsCount,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);

  NotificationResponseModel copyWith({
    bool? status,
    List<NotificationData>? data,
    List<dynamic>? error,
    int? unreadNotificationsCount,
  }) {
    return NotificationResponseModel(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
    );
  }
}

@JsonSerializable()
class NotificationData {
  final int? id;
  final String? title;
  final String? type;
  final String? description;
  final String? image;

  @JsonKey(name: 'is_read')
  final int? isRead;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  NotificationData({
    this.id,
    this.title,
    this.type,
    this.description,
    this.image,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

  NotificationData copyWith({
    int? id,
    String? title,
    String? type,
    String? description,
    String? image,
    int? isRead,
    String? createdAt,
    String? updatedAt,
    String? imageUrl,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
