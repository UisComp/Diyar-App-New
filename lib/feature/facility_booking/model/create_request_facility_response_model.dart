import 'package:json_annotation/json_annotation.dart';

part 'create_request_facility_response_model.g.dart';

@JsonSerializable()
class CreateRequestFacilityResponseModel {
  final bool? success;
  final String? message;
  final List<RequestFacilityData>? data;

  /// The HTTP status, filled in by the service after parsing. A `422` means
  /// the whole batch was rejected and **no** booking was created — either a
  /// chosen facility stopped taking bookings, or a slot clashed.
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? statusCode;

  CreateRequestFacilityResponseModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  /// True when the server refused the batch rather than failing outright.
  bool get isRejected => statusCode == 422;

  factory CreateRequestFacilityResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateRequestFacilityResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateRequestFacilityResponseModelToJson(this);
}

@JsonSerializable()
class RequestFacilityData {
  final int? id;

  @JsonKey(name: "booking_start")
  final String? bookingStart;

  @JsonKey(name: "booking_end")
  final String? bookingEnd;

  final String? status;
  final String? notes;
  final Facility? facility;

  RequestFacilityData({
    this.id,
    this.bookingStart,
    this.bookingEnd,
    this.status,
    this.notes,
    this.facility,
  });

  factory RequestFacilityData.fromJson(Map<String, dynamic> json) =>
      _$RequestFacilityDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestFacilityDataToJson(this);
}

@JsonSerializable()
class Facility {
  final int? id;
  final String? title;

  Facility({this.id, this.title});

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityToJson(this);
}
