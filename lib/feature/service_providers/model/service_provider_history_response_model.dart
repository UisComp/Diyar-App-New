import 'package:diyar_app/core/enums/bookable_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_provider_history_response_model.g.dart';

@JsonSerializable()
class ServiceProviderHistoryResponseModel {
  final bool? success;
  final String? message;
  final List<ServiceProviderBookingModel>? data;

  ServiceProviderHistoryResponseModel({this.success, this.message, this.data});

  factory ServiceProviderHistoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ServiceProviderHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ServiceProviderHistoryResponseModelToJson(this);
}

@JsonSerializable()
class ServiceProviderBookingModel {
  final int? id;

  @JsonKey(name: 'booking_date')
  final String? bookingDate;

  final String? status;
  final String? notes;

  @JsonKey(name: 'service_provider')
  final ServiceProviderModel? serviceProvider;

  final UserModel? user;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ServiceProviderBookingModel({
    this.id,
    this.bookingDate,
    this.status,
    this.notes,
    this.serviceProvider,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceProviderBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderBookingModelToJson(this);
}

@JsonSerializable()
class ServiceProviderModel {
  final int? id;

  @JsonKey(name: 'job_title')
  final String? jobTitle;

  final String? description;

  /// A booking keeps its provider even after staff change its status, so this
  /// is the one place `hidden` (with `is_active: false`) can show up.
  @JsonKey(
    unknownEnumValue: BookableStatus.unknown,
    defaultValue: BookableStatus.unknown,
  )
  final BookableStatus status;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  @JsonKey(name: 'is_bookable', defaultValue: false)
  final bool isBookable;

  final ServiceProviderIconModel? icon;

  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ServiceProviderModel({
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

  /// Whether this provider still takes new requests. A booking already made
  /// stays visible either way — this only gates offering another one.
  bool get canBook => isBookable && status.allowsBooking;

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderModelToJson(this);
}

@JsonSerializable()
class ServiceProviderIconModel {
  final int? id;
  final String? name;

  @JsonKey(name: 'file_name')
  final String? fileName;

  final String? url;
  final int? size;

  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  ServiceProviderIconModel({
    this.id,
    this.name,
    this.fileName,
    this.url,
    this.size,
    this.uploadedAt,
  });

  factory ServiceProviderIconModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderIconModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderIconModelToJson(this);
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
