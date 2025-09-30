import 'package:json_annotation/json_annotation.dart';
part 'request_model.g.dart';

@JsonSerializable()
class RequestModel {
  final String? name;
  final String? email;
  final String? password;
  @JsonKey(name: 'password_confirmation')
  final String? passwordConfirmation;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  RequestModel({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phoneNumber,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);
  RequestModel copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? phoneNumber,
  }) {
    return RequestModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
