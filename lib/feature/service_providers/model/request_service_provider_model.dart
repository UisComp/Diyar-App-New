import 'package:json_annotation/json_annotation.dart';

part 'request_service_provider_model.g.dart';

@JsonSerializable()
class RequestServiceProviderModel {
  @JsonKey(name: 'services')
  List<ServiceItem>? services;

  @JsonKey(name: 'booking_date')
  String? bookingDate;

  RequestServiceProviderModel({
    this.services,
    this.bookingDate,
  });

  factory RequestServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$RequestServiceProviderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RequestServiceProviderModelToJson(this);
}

@JsonSerializable()
class ServiceItem {
  int? id;
  String? title;

  ServiceItem({this.id, this.title});

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemToJson(this);

  factory ServiceItem.fromList(List<dynamic> list) {
    return ServiceItem(
      id: list.isNotEmpty ? list[0] : null,
      title: list.length > 1 ? list[1] : null,
    );
  }
}
