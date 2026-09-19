import 'dart:io';
import 'dart:typed_data';

import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/helper/sms_code_retriever.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/auth/model/user_phone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'fake_api.dart';

const testFcmToken = 'fcm-test-token';

/// Hive in a temp folder, in-memory secure storage, a fixed push token, no
/// SMS retriever and a fresh [FakeApi]. Call from `setUp`.
///
/// [inMemoryHive]: for widget tests. Their fake clock can't drive Hive's
/// file I/O, so the app's boxes are opened in memory instead.
Future<FakeApi> setUpAuthTestEnv({bool inMemoryHive = false}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (!_hiveReady) {
    final dir = await Directory.systemTemp.createTemp('diyar_auth_test');
    await HiveHelper.init(isTest: true, testPath: dir.path);
    if (inMemoryHive) {
      // HiveHelper's own openBox calls then get these boxes back.
      await Hive.openBox('modelbox', bytes: Uint8List(0));
      await Hive.openBox<LoginResponseModel>(
        'userModelBox',
        bytes: Uint8List(0),
      );
    }
    _hiveReady = true;
  }
  await HiveHelper.clearHive();
  await HiveHelper.clearUserDataOnly();
  FlutterSecureStorage.setMockInitialValues({});
  DeviceHelper.tokenReader = () async => testFcmToken;
  SmsCodeRetriever.listen = () async => null;
  SmsCodeRetriever.stop = () async {};
  await updateUserModel(null);
  enableBiometric = null;
  return FakeApi.install();
}

bool _hiveReady = false;

/// What login endpoints return in `data.user`.
Map<String, dynamic> userJson({
  int id = 16,
  String name = 'John Doe',
  String? email,
  List<String> roles = const ['user'],
  List<Map<String, dynamic>>? phones,
}) => {
  'id': id,
  'name': name,
  'email': email,
  'email_verified_at': null,
  'phones':
      phones ??
      [
        {
          'id': 3,
          'phone': '+201012345678',
          'is_primary': true,
          'verified': true,
        },
      ],
  'email_notifications': true,
  'profile_picture': null,
  'created_at': '2026-09-19T10:00:00.000000Z',
  'updated_at': '2026-09-19T10:00:00.000000Z',
  'roles': roles,
};

/// `data` of a successful login.
Map<String, dynamic> loginData({
  String token = '13|access',
  Map<String, dynamic>? user,
}) => {
  'access_token': token,
  'token_type': 'Bearer',
  'user': user ?? userJson(),
};

/// Puts a signed-in user in memory, like `main()` does from Hive.
Future<void> signIn({String token = '13|access', List<String>? roles}) =>
    updateUserModel(
      LoginResponseModel(
        success: true,
        data: LoginData(
          accessToken: token,
          tokenType: 'Bearer',
          user: User(
            id: 16,
            name: 'John Doe',
            roles: roles ?? const ['user'],
            phones: const [
              UserPhone(id: 3, phone: '+201012345678', isPrimary: true),
            ],
          ),
        ),
      ),
    );

/// Lets fire-and-forget work (e.g. the locale sync) finish. Each request
/// also passes through Dio's interceptors, which take a few turns.
Future<void> settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Future<Box<dynamic>> modelBox() => Hive.openBox('modelbox');
