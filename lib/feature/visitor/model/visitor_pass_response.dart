import 'package:json_annotation/json_annotation.dart';

part 'visitor_pass_response.g.dart';

@JsonSerializable()
class VisitorPassResponse {
  final bool ?success;
  final String? message;
  final VisitorPassData? data;

  VisitorPassResponse({this.success, this.message, this.data});

  factory VisitorPassResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitorPassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorPassResponseToJson(this);
}

@JsonSerializable()
class VisitorPassData {
  final int? id;
  final String? token;

  @JsonKey(name: 'visitor_name')
  final String? visitorName;

  final Unit? unit;

  @JsonKey(name: 'valid_from')
  final String? validFrom;

  @JsonKey(name: 'valid_until')
  final String? validUntil;

  @JsonKey(name: 'is_one_time_use')
  final bool? isOneTimeUse;

  VisitorPassData({
    this.id,
    this.token,
    this.visitorName,
    this.unit,
    this.validFrom,
    this.validUntil,
    this.isOneTimeUse,
  });

  factory VisitorPassData.fromJson(Map<String, dynamic> json) =>
      _$VisitorPassDataFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorPassDataToJson(this);
}

@JsonSerializable()
class Unit {
  final int? id;
  final String? name;

  Unit({this.id, this.name});

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
