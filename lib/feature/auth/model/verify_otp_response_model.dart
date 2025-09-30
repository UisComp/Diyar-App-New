import 'package:json_annotation/json_annotation.dart';
part 'verify_otp_response_model.g.dart';

@JsonSerializable()
class OtpVerificationResponse {
  final bool? success;
  final String? message;
  final OtpVerificationData? data;

  OtpVerificationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerificationResponseToJson(this);
}
@JsonSerializable()
class OtpVerificationData {
  @JsonKey(name: 'reset_token')
  final String? resetToken;

  OtpVerificationData({
    this.resetToken,
  });
  factory OtpVerificationData.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerificationDataToJson(this);
}