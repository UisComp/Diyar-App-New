import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileResponseModel({this.success, this.message, this.data});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}

@JsonSerializable()
class ProfileData {
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'profile_picture')
  final ProfilePicture? profilePicture;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ProfileData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profilePicture,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      emailVerifiedAt: json['email_verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      profilePicture: json['profile_picture'] != null ? ProfilePicture.fromJson(json['profile_picture']) : null,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}

@JsonSerializable()
class ProfilePicture {
  final int? id;
  final String? name;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? url;
  final String? size;
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  ProfilePicture({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.mimeType,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: ProfileData._toInt(json['id']),
      name: json['name']?.toString(),
      fileName: json['file_name']?.toString(),
      url: json['url']?.toString(),
      size: json['size']?.toString(),
      mimeType: json['mime_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$ProfilePictureToJson(this);
}
