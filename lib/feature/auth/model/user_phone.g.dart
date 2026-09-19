// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_phone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPhoneAdapter extends TypeAdapter<UserPhone> {
  @override
  final int typeId = 3;

  @override
  UserPhone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPhone(
      id: fields[0] as int,
      phone: fields[1] as String,
      isPrimary: fields[2] as bool,
      verified: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPhone obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.isPrimary)
      ..writeByte(3)
      ..write(obj.verified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPhoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPhone _$UserPhoneFromJson(Map<String, dynamic> json) => UserPhone(
  id: (json['id'] as num).toInt(),
  phone: json['phone'] as String,
  isPrimary: json['is_primary'] as bool? ?? false,
  verified: json['verified'] as bool? ?? false,
);

Map<String, dynamic> _$UserPhoneToJson(UserPhone instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'is_primary': instance.isPrimary,
  'verified': instance.verified,
};
