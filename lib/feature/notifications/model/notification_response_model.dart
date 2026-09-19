import 'package:json_annotation/json_annotation.dart';
part 'notification_response_model.g.dart';

/// `entity_type` values used to route notification taps.
abstract class NotificationEntityType {
  static const String facilityBooking = '1';
  static const String serviceProviderBooking = '2';
  static const String overdue = '3';
  static const String payment = '4';
}

String? stringOrNull(dynamic value) => value?.toString();

@JsonSerializable(explicitToJson: true)
class NotificationResponseModel {
  final bool? success;
  final String? message;
  final NotificationDataWrapper? data;
  final MetaData? meta;

  NotificationResponseModel({this.success, this.message, this.data, this.meta});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationDataWrapper {
  final List<NotificationData>? notifications;

  @JsonKey(name: 'unread_notifications_count')
  final int? unreadNotificationsCount;

  NotificationDataWrapper({this.notifications, this.unreadNotificationsCount});

  factory NotificationDataWrapper.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataWrapperToJson(this);
}

@JsonSerializable()
class NotificationData {
  final int? id;
  final String? title;
  final String? type;
  final String? description;
  final String? image;
  @JsonKey(name: 'title_ar')
  final String? titleAr;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  @JsonKey(name: 'is_read')
  final bool? isRead;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'image_url')
  final String? imageUrl;
  /// See [NotificationEntityType]. Arrives as a number from the API and as a
  /// string in push data, so it is normalized to a string.
  @JsonKey(name: 'entity_type', fromJson: stringOrNull)
  final String? entityType;
  @JsonKey(name: 'entity_id', fromJson: stringOrNull)
  final String? entityId;
  NotificationData({
    this.titleAr,
    this.descriptionAr,
    this.id,
    this.title,
    this.type,
    this.description,
    this.image,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.entityType,
    this.entityId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable()
class MetaData {
  final int? limit;
  final int? total;

  @JsonKey(name: "totalPages")
  final int? totalPages;

  final int? page;

  MetaData({this.limit, this.total, this.totalPages, this.page});

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}
