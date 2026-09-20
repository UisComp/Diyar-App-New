// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerificationResponse _$OtpVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    OtpVerificationResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OtpVerificationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpVerificationResponseToJson(
        OtpVerificationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

OtpVerificationData _$OtpVerificationDataFromJson(Map<String, dynamic> json) =>
    OtpVerificationData(
      resetToken: json['reset_token'] as String?,
    );

Map<String, dynamic> _$OtpVerificationDataToJson(
        OtpVerificationData instance) =>
    <String, dynamic>{
      'reset_token': instance.resetToken,
    };
