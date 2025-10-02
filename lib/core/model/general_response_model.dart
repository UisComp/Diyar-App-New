import 'package:json_annotation/json_annotation.dart';
part 'general_response_model.g.dart';

@JsonSerializable()
class GeneralResponseModel {
  final bool? success;
  final String? message;
  final dynamic data;

  GeneralResponseModel({this.success, this.message, this.data});

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseModelToJson(this);
}
