// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_booking_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityBookingHistoryResponseModel
    _$FacilityBookingHistoryResponseModelFromJson(Map<String, dynamic> json) =>
        FacilityBookingHistoryResponseModel(
          success: json['success'] as bool?,
          message: json['message'] as String?,
          data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  FacilityBookingData.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$FacilityBookingHistoryResponseModelToJson(
        FacilityBookingHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

FacilityBookingData _$FacilityBookingDataFromJson(Map<String, dynamic> json) =>
    FacilityBookingData(
      id: (json['id'] as num?)?.toInt(),
      bookingEnd: json['booking_end'] as String?,
      bookingStart: json['booking_start'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      facility: json['facility'] == null
          ? null
          : FacilityModel.fromJson(json['facility'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FacilityBookingDataToJson(
        FacilityBookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_start': instance.bookingStart,
      'booking_end': instance.bookingEnd,
      'status': instance.status,
      'notes': instance.notes,
      'facility': instance.facility,
      'user': instance.user,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

FacilityModel _$FacilityModelFromJson(Map<String, dynamic> json) =>
    FacilityModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      icon: json['icon'] == null
          ? null
          : FacilityIconModel.fromJson(json['icon'] as Map<String, dynamic>),
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FacilityModelToJson(FacilityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'is_active': instance.isActive,
      'icon': instance.icon,
      'icon_url': instance.iconUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

FacilityIconModel _$FacilityIconModelFromJson(Map<String, dynamic> json) =>
    FacilityIconModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileName: json['file_name'] as String?,
      url: json['url'] as String?,
      size: json['size'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$FacilityIconModelToJson(FacilityIconModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'url': instance.url,
      'size': instance.size,
      'uploaded_at': instance.uploadedAt,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
