import 'package:json_annotation/json_annotation.dart';
part 'make_all_notification_as_read_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MakeAllNotificationAsReadResponseModel {
  final bool? success;
  final String? message;
  final MakeAllNotificationAsReadData? data;
  final List<String>? error;

  MakeAllNotificationAsReadResponseModel({
    this.success,
    this.data,
    this.error,
    this.message,
  });

  factory MakeAllNotificationAsReadResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$MakeAllNotificationAsReadResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MakeAllNotificationAsReadResponseModelToJson(this);

  MakeAllNotificationAsReadResponseModel copyWith({
    bool? success,
    String? message,
    MakeAllNotificationAsReadData? data,
    List<String>? error,
  }) {
    return MakeAllNotificationAsReadResponseModel(
      message: message ?? this.message,
      success: success ?? this.success,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

@JsonSerializable()
class MakeAllNotificationAsReadData {
  final bool? success;
  @JsonKey(name: "updated_count")
  final int? updatedCount;

  MakeAllNotificationAsReadData({this.success, this.updatedCount});

  factory MakeAllNotificationAsReadData.fromJson(Map<String, dynamic> json) =>
      _$MakeAllNotificationAsReadDataFromJson(json);

  Map<String, dynamic> toJson() => _$MakeAllNotificationAsReadDataToJson(this);

  MakeAllNotificationAsReadData copyWith({bool? success, int? updatedCount}) {
    return MakeAllNotificationAsReadData(
      success: success ?? this.success,
      updatedCount: updatedCount ?? this.updatedCount,
    );
  }
}
