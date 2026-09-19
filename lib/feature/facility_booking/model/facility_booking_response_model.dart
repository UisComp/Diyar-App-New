import 'package:diyar_app/core/enums/bookable_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'facility_booking_response_model.g.dart';

@JsonSerializable()
class FacilityResponse {
  final bool? success;
  final String? message;
  final List<Facility>? data;

  FacilityResponse({this.success, this.message, this.data});

  factory FacilityResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityResponseToJson(this);
}

@JsonSerializable()
class Facility {
  final int? id;
  final String? title;
  final String? description;

  /// `active`, `booking_closed` or `hidden`; [BookableStatus.unknown] for
  /// anything a later backend adds, and when the key is missing.
  @JsonKey(
    unknownEnumValue: BookableStatus.unknown,
    defaultValue: BookableStatus.unknown,
  )
  final BookableStatus status;

  /// Whether the API still lists this facility. It is `true` for everything
  /// the list endpoint returns, including facilities that closed their
  /// bookings, so it is **not** a booking check — read [canBook] instead.
  @JsonKey(name: "is_active")
  final bool? isActive;

  /// The API's own booking gate. Defaults to `false`, so a facility from a
  /// backend that doesn't send the flag is treated as closed rather than
  /// wrongly bookable.
  @JsonKey(name: "is_bookable", defaultValue: false)
  final bool isBookable;

  final FacilityIcon? icon;

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
    this.status = BookableStatus.unknown,
    this.isActive,
    this.isBookable = false,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Whether the resident may book this facility. A facility that fails this
  /// is still listed, with a badge and a disabled control.
  bool get canBook => isBookable && status.allowsBooking;

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityToJson(this);
}

@JsonSerializable()
class FacilityIcon {
  final int? id;
  final String? name;

  @JsonKey(name: "file_name")
  final String? fileName;

  final String? url;
  @JsonKey(fromJson: _sizeFromJson, toJson: _sizeToJson)
  final int? size;

  @JsonKey(name: "uploaded_at")
  final String? uploadedAt;

  FacilityIcon({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory FacilityIcon.fromJson(Map<String, dynamic> json) =>
      _$FacilityIconFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityIconToJson(this);
}

int? _sizeFromJson(dynamic value) => value?.toInt();
int? _sizeToJson(int? value) => value;
