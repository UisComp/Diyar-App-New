import 'package:json_annotation/json_annotation.dart';
part 'facility_booking_response_model.g.dart';

@JsonSerializable()
class FacilityResponse {
  final bool? success;
  final String? message;
  final List<Facility>? data;

  FacilityResponse({
    this.success,
    this.message,
    this.data,
  });

  factory FacilityResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityResponseToJson(this);
}

@JsonSerializable()
class Facility {
  final int? id;
  final String? title;
  final String? description;

  @JsonKey(name: "is_active")
  final bool? isActive;

  final String? icon;

  @JsonKey(name: "icon_url")
  final String? iconUrl;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Facility({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityToJson(this);
}
