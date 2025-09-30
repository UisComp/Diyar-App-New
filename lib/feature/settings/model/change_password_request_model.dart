import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable()
class ChangePasswordRequestModel {
  @JsonKey(name: 'current_password')
  final String? currentPassword;

  @JsonKey(name: 'new_password')
  final String? newPassword;

  @JsonKey(name: 'new_password_confirmation')
  final String? newPasswordConfirmation;

  ChangePasswordRequestModel({
    this.currentPassword,
    this.newPassword,
    this.newPasswordConfirmation,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);
}
