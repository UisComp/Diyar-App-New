import 'package:json_annotation/json_annotation.dart';
part 'general_notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GeneralNotificationModel {
  final bool? status;
  final NotificationDataBody? data;
  final List<dynamic>? error;

  GeneralNotificationModel({
    this.status,
    this.data,
    this.error,
  });

  factory GeneralNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralNotificationModelToJson(this);

  GeneralNotificationModel copyWith({
    bool? status,
    NotificationDataBody? data,
    List<dynamic>? error,
  }) {
    return GeneralNotificationModel(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

@JsonSerializable()
class NotificationDataBody {
  final String? message;

  NotificationDataBody({
    this.message,
  });

  factory NotificationDataBody.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataBodyToJson(this);

  NotificationDataBody copyWith({
    String? message,
  }) {
    return NotificationDataBody(
      message: message ?? this.message,
    );
  }
}
