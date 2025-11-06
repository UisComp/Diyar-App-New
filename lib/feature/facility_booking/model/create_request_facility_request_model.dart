import 'package:json_annotation/json_annotation.dart';
part 'create_request_facility_request_model.g.dart';

@JsonSerializable()
class CreateRequestFacilityRequestModel {
  @JsonKey(name: "facility_ids")
  final List<int>? facilityIds;

  @JsonKey(name: "booking_date")
  final String? bookingDate;

  final String? notes;

  CreateRequestFacilityRequestModel({
    this.facilityIds,
    this.bookingDate,
    this.notes,
  });

  factory CreateRequestFacilityRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateRequestFacilityRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateRequestFacilityRequestModelToJson(this);
}
