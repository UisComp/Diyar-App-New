import 'package:json_annotation/json_annotation.dart';
part 'create_request_facility_request_model.g.dart';

@JsonSerializable()
class CreateRequestFacilityRequestModel {
  @JsonKey(name: "facilities")
  final List<FacilityItem>? facilities;

  CreateRequestFacilityRequestModel({this.facilities});

  factory CreateRequestFacilityRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateRequestFacilityRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateRequestFacilityRequestModelToJson(this);
}

@JsonSerializable()
class FacilityItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'notes')
  String? notes;

  @JsonKey(name: 'booking_start')
  String? bookingStart;

  @JsonKey(name: 'booking_end')
  String? bookingEnd;

  FacilityItem({this.id, this.notes, this.bookingStart, this.bookingEnd});

  factory FacilityItem.fromJson(Map<String, dynamic> json) =>
      _$FacilityItemFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityItemToJson(this);
}
