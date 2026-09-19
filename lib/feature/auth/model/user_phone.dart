import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_phone.g.dart';

/// One of the account's phone numbers. Any of them logs in; the primary one
/// gets SMS messages.
@HiveType(typeId: 3)
@JsonSerializable()
class UserPhone {
  const UserPhone({
    required this.id,
    required this.phone,
    this.isPrimary = false,
    this.verified = false,
  });

  @HiveField(0)
  final int id;

  /// International form, e.g. `+201012345678`.
  @HiveField(1)
  final String phone;

  @HiveField(2)
  @JsonKey(name: 'is_primary', defaultValue: false)
  final bool isPrimary;

  /// False when staff added the number and it hasn't logged in yet.
  @HiveField(3)
  @JsonKey(defaultValue: false)
  final bool verified;

  factory UserPhone.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneFromJson(json);

  Map<String, dynamic> toJson() => _$UserPhoneToJson(this);
}

/// Parses a `phones` list, skipping malformed entries.
List<UserPhone> parseUserPhones(dynamic json) => [
  if (json is List)
    for (final item in json)
      if (item is Map && item['id'] != null && item['phone'] != null)
        UserPhone.fromJson(Map<String, dynamic>.from(item)),
];

extension UserPhonesX on List<UserPhone> {
  /// The primary number, or the first one if none is marked primary.
  UserPhone? get primary {
    if (isEmpty) return null;
    return firstWhere((p) => p.isPrimary, orElse: () => first);
  }
}
