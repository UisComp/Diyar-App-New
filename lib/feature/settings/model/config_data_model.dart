import 'package:json_annotation/json_annotation.dart';

part 'config_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConfigResponseModel {
  final bool? success;
  final String? message;
  final ConfigData? data;

  ConfigResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory ConfigResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigResponseModelToJson(this);
}

@JsonSerializable()
class ConfigData {
  @JsonKey(name: "contact_email")
  final String? contactEmail;

  @JsonKey(name: "contact_phone")
  final String? contactPhone;

  @JsonKey(name: "emergency_number")
  final String? emergencyNumber;

  ConfigData({
    this.contactEmail,
    this.contactPhone,
    this.emergencyNumber,
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) =>
      _$ConfigDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigDataToJson(this);
}
