import 'package:json_annotation/json_annotation.dart';

part 'visitor_pass_request.g.dart';

@JsonSerializable()
class VisitorPassRequest {
  @JsonKey(name: 'unit_id')
  final int? unitId;

  @JsonKey(name: 'visitor_name')
  final String? visitorName;

  @JsonKey(name: 'visitor_phone')
  final String? visitorPhone;

  @JsonKey(name: 'visitor_vehicle')
  final String? visitorVehicle;

  final String? purpose;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'end_time')
  final String? endTime;

  @JsonKey(name: 'is_one_time_use')
  final bool? isOneTimeUse;

  VisitorPassRequest({
    this.unitId,
    this.visitorName,
    this.visitorPhone,
    this.visitorVehicle,
    this.purpose,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.isOneTimeUse,
  });

  factory VisitorPassRequest.fromJson(Map<String, dynamic> json) =>
      _$VisitorPassRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorPassRequestToJson(this);
}
