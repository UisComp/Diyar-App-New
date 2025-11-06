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
  final String? size;

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

  @JsonKey(name: 'is_active')
  final bool? isActive;

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
