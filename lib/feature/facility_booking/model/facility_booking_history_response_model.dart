import 'package:json_annotation/json_annotation.dart';

part 'facility_booking_history_response_model.g.dart';

@JsonSerializable()
class FacilityBookingHistoryResponseModel {
  final bool? success;
  final String? message;
  final List<FacilityBookingData>? data;

  FacilityBookingHistoryResponseModel({this.success, this.message, this.data});

  factory FacilityBookingHistoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$FacilityBookingHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FacilityBookingHistoryResponseModelToJson(this);
}

@JsonSerializable()
class FacilityBookingData {
  final int? id;

  @JsonKey(name: "booking_start")
  final String? bookingStart;

  @JsonKey(name: "booking_end")
  final String? bookingEnd;

  final String? status;
  final String? notes;
  final FacilityModel? facility;
  final UserModel? user;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  FacilityBookingData({
    this.id,
    this.bookingEnd,
    this.bookingStart,
    this.status,
    this.notes,
    this.facility,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory FacilityBookingData.fromJson(Map<String, dynamic> json) =>
      _$FacilityBookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityBookingDataToJson(this);
}

@JsonSerializable()
class FacilityModel {
  final int? id;
  final String? title;
  final String? description;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  final FacilityIconModel? icon;

  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  FacilityModel({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityModelToJson(this);
}

@JsonSerializable()
class FacilityIconModel {
  final int? id;
  final String? name;

  @JsonKey(name: 'file_name')
  final String? fileName;

  final String? url;
  final String? size;

  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  FacilityIconModel({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory FacilityIconModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityIconModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityIconModelToJson(this);
}

@JsonSerializable()
class UserModel {
  final int? id;
  final String? name;
  final String? email;

  UserModel({this.id, this.name, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
