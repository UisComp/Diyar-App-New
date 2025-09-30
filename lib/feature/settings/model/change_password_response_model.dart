import 'package:json_annotation/json_annotation.dart';
part 'change_password_response_model.g.dart';

@JsonSerializable()
class ChangePasswordResponseModel {
  final bool ?success;
  final String ?message;
  final dynamic data;       

  ChangePasswordResponseModel({
     this.success,
     this.message,
    this.data,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseModelToJson(this);
}
