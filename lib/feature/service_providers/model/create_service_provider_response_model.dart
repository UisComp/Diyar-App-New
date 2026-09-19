import 'package:json_annotation/json_annotation.dart';
part 'create_service_provider_response_model.g.dart';

@JsonSerializable()
class CreateServiceProviderResponseModel {
  final bool? success;
  final String? message;
  final List<ServiceBookingData>? data;

  /// The HTTP status, filled in by the service after parsing. A `422` means
  /// the whole batch was rejected and **no** booking was created — usually
  /// because one of the chosen providers stopped taking bookings.
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? statusCode;

  CreateServiceProviderResponseModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  /// True when the server refused the batch rather than failing outright.
  bool get isRejected => statusCode == 422;

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
