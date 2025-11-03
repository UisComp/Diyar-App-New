import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_services_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserServicesResponse extends Equatable {
  final bool? success;
  final String? message;
  final List<UserServiceData>? data;

  const UserServicesResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UserServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$UserServicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserServicesResponseToJson(this);

  UserServicesResponse copyWith({
    bool? success,
    String? message,
    List<UserServiceData>? data,
  }) {
    return UserServicesResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable(explicitToJson: true)
class UserServiceData extends Equatable {
  final int? id;
  final String? name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'localized_name')
  final String? localizedName;

  final String? description;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  final List<Role>? roles;
  final int? type;
  final IconDataModel? icon;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const UserServiceData({
    this.id,
    this.name,
    this.nameAr,
    this.localizedName,
    this.description,
    this.isActive,
    this.roles,
    this.type,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory UserServiceData.fromJson(Map<String, dynamic> json) =>
      _$UserServiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserServiceDataToJson(this);

  UserServiceData copyWith({
    int? id,
    String? name,
    String? nameAr,
    String? localizedName,
    String? description,
    bool? isActive,
    List<Role>? roles,
    int? type,
    IconDataModel? icon,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserServiceData(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      localizedName: localizedName ?? this.localizedName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      roles: roles ?? this.roles,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        localizedName,
        description,
        isActive,
        roles,
        type,
        icon,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class Role extends Equatable {
  final int? id;
  final String? name;

  const Role({this.id, this.name});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);

  Role copyWith({
    int? id,
    String? name,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class IconDataModel extends Equatable {
  final int? id;
  final String? name;

  @JsonKey(name: 'file_name')
  final String? fileName;

  final String? url;
  final String? size;

  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  const IconDataModel({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory IconDataModel.fromJson(Map<String, dynamic> json) =>
      _$IconDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$IconDataModelToJson(this);

  IconDataModel copyWith({
    int? id,
    String? name,
    String? fileName,
    String? url,
    String? size,
    String? uploadedAt,
  }) {
    return IconDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      size: size ?? this.size,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, fileName, url, size, uploadedAt];
}
