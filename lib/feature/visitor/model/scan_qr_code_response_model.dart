import 'package:json_annotation/json_annotation.dart';

part 'scan_qr_code_response_model.g.dart';

@JsonSerializable()
class ScanQrCodeResponseModel {
  final bool? success;
  final String? message;
  final ScanQrCodeData? data;

  ScanQrCodeResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory ScanQrCodeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScanQrCodeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanQrCodeResponseModelToJson(this);
}

@JsonSerializable()
class ScanQrCodeData {
  final bool? valid;
  @JsonKey(name: 'visitor_name')
  final String? visitorName;

  @JsonKey(name: 'visitor_phone')
  final String? visitorPhone;

  @JsonKey(name: 'visitor_vehicle')
  final String? visitorVehicle;

  final String? purpose;
  final Unit? unit;
  final Owner? owner;

  @JsonKey(name: 'valid_until')
  final String? validUntil;

  @JsonKey(name: 'first_scan')
  final bool? firstScan;

  @JsonKey(name: 'scan_count')
  final String? scanCount;

  @JsonKey(name: 'is_one_time_use')
  final bool? isOneTimeUse;

  ScanQrCodeData({
    this.valid,
    this.visitorName,
    this.visitorPhone,
    this.visitorVehicle,
    this.purpose,
    this.unit,
    this.owner,
    this.validUntil,
    this.firstScan,
    this.scanCount,
    this.isOneTimeUse,
  });

  factory ScanQrCodeData.fromJson(Map<String, dynamic> json) =>
      _$ScanQrCodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ScanQrCodeDataToJson(this);
}

@JsonSerializable()
class Unit {
  final int? id;
  final String? name;

  Unit({this.id, this.name});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

@JsonSerializable()
class Owner {
  final String? name;
  final String? phone;

  Owner({this.name, this.phone});

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
