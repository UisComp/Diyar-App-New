import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class LoginResponseModel {
  @HiveField(0)
  final bool? success;

  @HiveField(1)
  final String? message;

  @HiveField(2)
  final LoginData? data;

  LoginResponseModel({this.success, this.message, this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class LoginData {
  @HiveField(0)
  @JsonKey(name: 'access_token')
  final String accessToken;

  @HiveField(1)
  @JsonKey(name: 'token_type')
  final String tokenType;

  @HiveField(2)
  final User user;

  LoginData({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @HiveField(4)
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @HiveField(5)
  @JsonKey(name: 'created_at')
  final String createdAt;

  @HiveField(6)
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
