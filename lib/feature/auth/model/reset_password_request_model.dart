import 'package:json_annotation/json_annotation.dart';
part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel {
  @JsonKey(name: 'reset_token')
  final String? token;
  final String? email;
  final String? password;
  @JsonKey(name: 'password_confirmation')
  final String? passwordConfirmation;

  ResetPasswordRequestModel({
    this.token,
    this.email,
    this.password,
    this.passwordConfirmation,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestModelToJson(this);
}
