import 'package:json_annotation/json_annotation.dart';

part 'request_service_provider_model.g.dart';

@JsonSerializable()
class RequestServiceProviderModel {
  @JsonKey(name: 'services')
  List<ServiceItem>? services;

  RequestServiceProviderModel({this.services});

  factory RequestServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$RequestServiceProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestServiceProviderModelToJson(this);
}

@JsonSerializable()
class ServiceItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'booking_date')
  String? bookingDate;

  ServiceItem({this.id, this.title, this.bookingDate});

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemToJson(this);
}
