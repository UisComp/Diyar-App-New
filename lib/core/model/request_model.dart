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
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  RequestModel({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phoneNumber,
    this.fcmToken,
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
    String? fcmToken,
  }) {
    return RequestModel(
      fcmToken: fcmToken ?? this.fcmToken,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
