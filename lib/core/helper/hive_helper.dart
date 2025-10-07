import 'dart:io';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

//! Don't forget to change type of model
abstract class HiveHelper {
  //! For Test
  static Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init(Directory.current.path);
    } else {
      await Hive.initFlutter();
      Hive.registerAdapter(LoginResponseModelAdapter());
      Hive.registerAdapter(LoginDataAdapter());
      Hive.registerAdapter(UserAdapter());
    }
  }

  static dynamic boxList;
  static dynamic boxVars;
  static Future<void> storeList<T>(List<T> list, String listKey) async {
    final box = await Hive.openBox<T>(listKey);
    await box.clear();
    await box.addAll(list);
  }

  static Future<List<T>> getList<T>(String listKey) async {
    final box = await Hive.openBox<T>(listKey);
    return box.values.toList();
  }

  static Future<void> storeUserModel(
    LoginResponseModel userModel,
    String key,
  ) async {
    final box = await Hive.openBox<LoginResponseModel>('userModelBox');
    await box.put(key, userModel);
  }

  static Future<LoginResponseModel?> getUserModel(String key) async {
    final box = await Hive.openBox<LoginResponseModel>('userModelBox');
    return box.get(key);
  }

  // static Future<void> addToHive<T>({
  //   required String key,
  //   required T value,
  // }) async {
  //   final box = await Hive.openBox<T>('modelBox');
  //   await box.put(key, value);
  // }

  // static Future<T?> getFromHive<T>({required String key}) async {
  //   final box = await Hive.openBox<T>('modelBox');
  //   return box.get(key);
  // }

  static Future<void> removeFromHive({required String key}) async {
    final box = await Hive.openBox('modelBox');
    await box.delete(key);
  }

  static Future<void> clearAllData() async {
    final userBox = await Hive.openBox<LoginResponseModel>('userModelBox');
    await userBox.clear();

    final modelBox = await Hive.openBox('modelBox');
    await modelBox.clear();
  }

  static Box? _box;

  static Future<Box> _openBox() async {
    _box ??= await Hive.openBox('modelbox');
    return _box!;
  }

  static Future<void> addToHive({
    required String key,
    required dynamic value,
  }) async {
    final box = await _openBox();
    await box.put(key, value);
  }

  static Future<dynamic> getFromHive({required String key}) async {
    final box = await _openBox();
    return box.get(key);
  }

  static Future<void> clearHive() async {
    final box = await _openBox();
    await box.clear();
  }
}
