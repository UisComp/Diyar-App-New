import 'package:json_annotation/json_annotation.dart';
part 'reset_or_forget_password_response_model.g.dart';

@JsonSerializable()
class ResetOrForgetPasswordResponseModel {
  final bool ?success;
  final String ?message;
  final dynamic data;  

  ResetOrForgetPasswordResponseModel({
     this.success,
     this.message,
    this.data,
  });

  factory ResetOrForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResetOrForgetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetOrForgetPasswordResponseModelToJson(this);
}
