import 'package:json_annotation/json_annotation.dart';
part 'facility_booking_response_model.g.dart';

@JsonSerializable()
class FacilityModel {
  final String? url;
  final String? title;
  final String? description;

  FacilityModel({this.url, this.title, this.description});

  /// Factory method for creating a FacilityModel from JSON
  factory FacilityModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityModelFromJson(json);

  /// Converts the FacilityModel to JSON
  Map<String, dynamic> toJson() => _$FacilityModelToJson(this);
}
