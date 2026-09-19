import 'package:diyar_app/core/enums/bookable_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_provider_response.g.dart';

@JsonSerializable()
class ServiceProviderResponse {
  final bool? success;
  final String? message;
  final List<ServiceProvider>? data;

  ServiceProviderResponse({this.success, this.message, this.data});

  factory ServiceProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderResponseToJson(this);
}

@JsonSerializable()
class IconModel {
  final int? id;
  final String? name;

  @JsonKey(name: 'file_name')
  final String? fileName;

  final String? url;
  @JsonKey(fromJson: _sizeFromJson, toJson: _sizeToJson)
  final int? size;

  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  IconModel({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory IconModel.fromJson(Map<String, dynamic> json) =>
      _$IconModelFromJson(json);

  Map<String, dynamic> toJson() => _$IconModelToJson(this);
}

@JsonSerializable()
class ServiceProvider {
  final int? id;

  @JsonKey(name: 'job_title')
  final String? jobTitle;

  final String? description;

  /// `active`, `booking_closed` or `hidden`; [BookableStatus.unknown]
  /// for anything a later backend adds, and when the key is missing.
  @JsonKey(
    unknownEnumValue: BookableStatus.unknown,
    defaultValue: BookableStatus.unknown,
  )
  final BookableStatus status;

  /// Whether the API still lists this provider. It is `true` for everything
  /// the list endpoint returns, including providers that closed their
  /// bookings, so it is **not** a booking check — read [canBook] instead.
  @JsonKey(name: 'is_active')
  final bool? isActive;

  /// The API's own booking gate. Defaults to `false`, so a provider from a
  /// backend that doesn't send the flag is treated as closed rather than
  /// wrongly bookable.
  @JsonKey(name: 'is_bookable', defaultValue: false)
  final bool isBookable;

  final IconModel? icon;

  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ServiceProvider({
    this.id,
    this.jobTitle,
    this.description,
    this.status = BookableStatus.unknown,
    this.isActive,
    this.isBookable = false,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Whether the resident may request this provider. A provider that fails
  /// this is still listed, with a badge and a disabled control.
  bool get canBook => isBookable && status.allowsBooking;

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}

int? _sizeFromJson(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '');
int? _sizeToJson(int? value) => value;
