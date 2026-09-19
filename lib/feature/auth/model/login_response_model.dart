import 'package:diyar_app/feature/auth/model/user_phone.dart';
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
@JsonSerializable(explicitToJson: true)
class User {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  /// Optional for residents.
  @HiveField(2)
  final String? email;
  // HiveField(3) was `phone_number`, which the API no longer sends. Don't
  // reuse the index: sessions saved by older versions still carry it.
  @HiveField(4)
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @HiveField(5)
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @HiveField(6)
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @HiveField(7)
  final List<String>? roles;

  /// Primary number first. Null in sessions saved by older versions.
  @HiveField(8)
  @JsonKey(fromJson: parseUserPhones)
  final List<UserPhone>? phones;

  User({
    this.roles,
    required this.id,
    required this.name,
    this.email,
    this.phones,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// The number SMS messages go to.
  UserPhone? get primaryPhone => phones?.primary;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
