import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_units_response_model.g.dart';

@JsonSerializable()
class UserUnitsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<UserUnit>? data;

  const UserUnitsResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserUnitsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserUnitsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserUnitsResponseModelToJson(this);

  UserUnitsResponseModel copyWith({
    bool? success,
    String? message,
    List<UserUnit>? data,
  }) {
    return UserUnitsResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable()
class UserUnit extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'project_id')
  final int? projectId;

  const UserUnit({
    this.id,
    this.name,
    this.userId,
    this.projectId,
  });

  factory UserUnit.fromJson(Map<String, dynamic> json) {
    return UserUnit(
      id: _toInt(json['id']),
      name: json['name'] as String?,
      userId: _toInt(json['user_id']),
      projectId: _toInt(json['project_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user_id': userId,
        'project_id': projectId,
      };

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    return null;
  }

  UserUnit copyWith({
    int? id,
    String? name,
    int? userId,
    int? projectId,
  }) {
    return UserUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [id, name, userId, projectId];
}
