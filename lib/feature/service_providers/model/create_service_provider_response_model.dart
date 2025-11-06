import 'package:json_annotation/json_annotation.dart';
part 'create_service_provider_response_model.g.dart';

@JsonSerializable()
class CreateServiceProviderResponseModel {
  final bool? success;
  final String? message;
  final List<ServiceBookingData>? data;

  CreateServiceProviderResponseModel({this.success, this.message, this.data});

  factory CreateServiceProviderResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateServiceProviderResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateServiceProviderResponseModelToJson(this);
}

@JsonSerializable()
class ServiceBookingData {
  final int? id;

  @JsonKey(name: 'booking_date')
  final String? bookingDate;

  final String? status;
  final String? notes;

  @JsonKey(name: 'service_provider')
  final ServiceProvider? serviceProvider;

  ServiceBookingData({
    this.id,
    this.bookingDate,
    this.status,
    this.notes,
    this.serviceProvider,
  });

  factory ServiceBookingData.fromJson(Map<String, dynamic> json) =>
      _$ServiceBookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceBookingDataToJson(this);
}

@JsonSerializable()
class ServiceProvider {
  final int? id;

  @JsonKey(name: 'job_title')
  final String? jobTitle;

  ServiceProvider({this.id, this.jobTitle});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}
