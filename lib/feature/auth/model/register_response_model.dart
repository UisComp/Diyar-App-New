import 'package:json_annotation/json_annotation.dart';
part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final bool? success;
  final String? message;
  final RegisterData? data;

  RegisterResponseModel({this.success, this.message, this.data});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

@JsonSerializable()
class RegisterData {
  final int? id;
  final String? name;
  final String? email;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  RegisterData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
