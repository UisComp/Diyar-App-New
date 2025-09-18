import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
//! Don't forget to change type of model
abstract class HiveHelper {
  //! For Test
  static Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init(Directory.current.path);
    } else {
      await Hive.initFlutter();
    }
  }

  static dynamic boxList;
  static dynamic boxVars;

  static Future<void> storeList(List<dynamic> list, String listKey) async {
    boxList = await Hive.openBox<dynamic>(listKey);
    await boxList.clear();
    await boxList.addAll(list);
  }

  static Future<List<dynamic>> getList(String listKey) async {
    boxList = await Hive.openBox<dynamic>(listKey);
    return boxList.values.toList();
  }

  static Future<void> storeUserModel(dynamic userModel, String key) async {
    final box = await Hive.openBox<dynamic>('userModelBox');
    await box.put(key, userModel);
  }

  static Future<void> addToHive({
    required String key,
    required dynamic value,
  }) async {
    boxVars = await Hive.openBox('modelBox');
    await boxVars.put(key, value);
  }

  static Future<dynamic> getFromHive({required String key}) async {
    boxVars = await Hive.openBox('modelBox');
    return boxVars.get(key);
  }

  static Future<void> removeFromHive({required String key}) async {
    boxVars = await Hive.openBox('modelBox');
    await boxVars.delete(key);
  }

  static Future<void> clearAllData() async {
    if (boxList != null) {
      await boxList.clear();
    }
    if (boxVars != null) {
      await boxVars.clear();
    }
    final userBox = await Hive.openBox<dynamic>('userModelBox');
    await userBox.clear();
  }
}
