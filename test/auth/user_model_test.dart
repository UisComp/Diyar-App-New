import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/model/user_phone.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../helpers/auth_test_env.dart';

/// `User` as older app versions stored it: `phone_number` in field 3, no
/// `phones`, email required.
class _LegacyUserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) => throw UnimplementedError();

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write('+201000000000')
      ..writeByte(4)
      ..write(obj.emailVerifiedAt)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.roles);
  }
}

void main() {
  setUp(setUpAuthTestEnv);

  group('User (§8)', () {
    test('reads phones, primary first; email may be null', () {
      final user = User.fromJson(
        userJson(
          phones: [
            {
              'id': 5,
              'phone': '+201112345678',
              'is_primary': false,
              'verified': false,
            },
            {
              'id': 3,
              'phone': '+201012345678',
              'is_primary': true,
              'verified': true,
            },
          ],
        ),
      );
      expect(user.email, isNull);
      expect(user.phones, hasLength(2));
      expect(user.primaryPhone!.id, 3);
      expect(user.phones!.first.verified, isFalse);
    });

    test('no phones and malformed entries are tolerated', () {
      final noPhones = User.fromJson(userJson()..remove('phones'));
      expect(noPhones.phones, isEmpty);
      expect(noPhones.primaryPhone, isNull);

      final malformed = User.fromJson(
        userJson(
          phones: [
            {'id': 1},
            {'id': 2, 'phone': '+201000000001'},
          ],
        ),
      );
      expect(malformed.phones!.single.id, 2);
      // Nothing marked primary: fall back to the first number.
      expect(malformed.primaryPhone!.id, 2);
    });

    test('ProfileData reads phones and drops phone_number', () {
      final profile = ProfileData.fromJson(
        userJson(email: 'john@example.com')..['phone_number'] = '+2000',
      );
      expect(profile.primaryPhone?.phone, '+201012345678');
      expect(profile.email, 'john@example.com');
    });

    test('a new session round-trips through Hive', () async {
      final model = LoginResponseModel.fromJson({
        'success': true,
        'message': 'ok',
        'data': loginData(),
      });
      await HiveHelper.storeUserModel(model, AppConstants.userModelKey);
      final stored = await HiveHelper.getUserModel(AppConstants.userModelKey);
      expect(stored!.data!.accessToken, '13|access');
      expect(stored.data!.user.primaryPhone!.phone, '+201012345678');
      expect(stored.data!.user.email, isNull);
    });

    test('a session saved by an older version still opens', () async {
      final box = await Hive.openBox<LoginResponseModel>('legacyBox');
      Hive.registerAdapter(_LegacyUserAdapter(), override: true);
      await box.put(
        'user',
        LoginResponseModel(
          success: true,
          data: LoginData(
            accessToken: 'old-token',
            tokenType: 'Bearer',
            user: User(
              id: 1,
              name: 'Old Resident',
              email: 'old@example.com',
              createdAt: '2025-01-01',
              updatedAt: '2025-01-01',
              roles: const ['user'],
            ),
          ),
        ),
      );
      await box.close();
      Hive.registerAdapter(UserAdapter(), override: true);

      final reopened = await Hive.openBox<LoginResponseModel>('legacyBox');
      final user = reopened.get('user')!.data!.user;
      expect(user.name, 'Old Resident');
      expect(user.email, 'old@example.com');
      expect(user.phones, isNull);
      expect(user.primaryPhone, isNull);
      await reopened.deleteFromDisk();
    });
  });

  group('displayPhone', () {
    test('groups international numbers', () {
      expect(displayPhone('+201012345678'), '+20 10 12345678');
      expect(displayPhone('+971501234567'), '+971 50 123 4567');
    });

    test('leaves what it cannot parse', () {
      expect(displayPhone('abc'), 'abc');
    });
  });

  test('UserPhones.primary on an empty list', () {
    expect(<UserPhone>[].primary, isNull);
  });
}
