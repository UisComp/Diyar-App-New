import 'package:json_annotation/json_annotation.dart';

part 'service_provider_response.g.dart';

@JsonSerializable()
class ServiceProviderResponse {
  final bool? success;
  final String? message;
  final List<ServiceProvider>? data;

  ServiceProviderResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderResponseToJson(this);
}

@JsonSerializable()
class ServiceProvider {
  final int? id;

  @JsonKey(name: 'job_title')
  final String? jobTitle;

  final String? description;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  final String? icon;

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
    this.isActive,
    this.icon,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}
