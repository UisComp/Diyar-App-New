import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_units_response_model.g.dart';

@JsonSerializable()
class UserUnitsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<UserUnit>? data;

  const UserUnitsResponseModel({this.success, this.message, this.data});

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

/// A unit in `GET /api/units` (the owner's units). `name` can be null:
/// display [label].
@JsonSerializable()
class UserUnit extends Equatable {
  final int? id;
  final String? name;
  final ProfilePicture? imageUrl;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'project_id')
  final int? projectId;
  final String? code;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? apiLabel;
  final int? floor;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final UnitStatus status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Building? building;

  const UserUnit({
    this.id,
    this.name,
    this.userId,
    this.projectId,
    this.imageUrl,
    this.code,
    this.apiLabel,
    this.floor,
    this.status = UnitStatus.unknown,
    this.building,
  });

  factory UserUnit.fromJson(Map<String, dynamic> json) {
    final building = json['building'];
    return UserUnit(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      userId: _toInt(json['user_id']),
      projectId: _toInt(json['project_id']),
      imageUrl: json['main_image'] is Map<String, dynamic>
          ? ProfilePicture.fromJson(json['main_image'])
          : null,
      code: json['code']?.toString(),
      apiLabel: json['label']?.toString(),
      floor: _toInt(json['floor']),
      status: UnitStatus.parse(json['status']),
      building: building is Map
          ? Building.fromJson(Map<String, dynamic>.from(building))
          : null,
    );
  }

  /// "Town 1 · T-1-G": the API's label, falling back to name then code.
  String get label => apiLabel ?? name ?? code ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'label': apiLabel,
    'floor': floor,
    'status': status.name,
    'user_id': userId,
    'project_id': projectId,
    'main_image': imageUrl,
  };

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    userId,
    projectId,
    imageUrl,
    code,
    apiLabel,
    floor,
    status,
    building?.id,
  ];
}
