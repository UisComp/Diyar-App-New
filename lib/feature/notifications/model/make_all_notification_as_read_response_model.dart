import 'package:json_annotation/json_annotation.dart';
part 'make_all_notification_as_read_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MakeAllNotificationAsReadResponseModel {
  final bool status;
  final MakeAllNotificationAsReadData? data;
  final List<String>? error;

  MakeAllNotificationAsReadResponseModel({
    required this.status,
    this.data,
    this.error,
  });

  factory MakeAllNotificationAsReadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MakeAllNotificationAsReadResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MakeAllNotificationAsReadResponseModelToJson(this);

  MakeAllNotificationAsReadResponseModel copyWith({
    bool? status,
    MakeAllNotificationAsReadData? data,
    List<String>? error,
  }) {
    return MakeAllNotificationAsReadResponseModel(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

@JsonSerializable()
class MakeAllNotificationAsReadData {
  final String message;

  MakeAllNotificationAsReadData({
    required this.message,
  });

  factory MakeAllNotificationAsReadData.fromJson(Map<String, dynamic> json) =>
      _$MakeAllNotificationAsReadDataFromJson(json);

  Map<String, dynamic> toJson() => _$MakeAllNotificationAsReadDataToJson(this);

  MakeAllNotificationAsReadData copyWith({
    String? message,
  }) {
    return MakeAllNotificationAsReadData(
      message: message ?? this.message,
    );
  }
}
