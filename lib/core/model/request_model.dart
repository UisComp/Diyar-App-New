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
  @JsonKey(name: 'project_id')
  final int? projectId;

  /// e.g. `B1-G-01`. The server trims and upper-cases it.
  @JsonKey(name: 'unit_code')
  final String? unitCode;

  RequestModel({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phoneNumber,
    this.fcmToken,
    this.projectId,
    this.unitCode,
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
    int? projectId,
    String? unitCode,
  }) {
    return RequestModel(
      projectId: projectId ?? this.projectId,
      unitCode: unitCode ?? this.unitCode,
      fcmToken: fcmToken ?? this.fcmToken,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
