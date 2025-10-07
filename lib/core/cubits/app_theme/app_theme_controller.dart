import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

class AppThemeController extends Cubit<AppThemeState> {
  AppThemeController() : super(AppThemeInitial()) {
    _loadThemeFromHive();
  }

  static AppThemeController get(BuildContext context) =>
      BlocProvider.of(context);
  AppThemeMode currentThemeMode = AppThemeMode.system;

  Future<void> _loadThemeFromHive() async {
    final storedValue =
        await HiveHelper.getFromHive(key: AppConstants.hiveDarkMode);

    if (storedValue is String) {
      currentThemeMode = AppThemeMode.values.firstWhere(
        (e) => e.toString() == storedValue,
        orElse: () => AppThemeMode.system,
      );
    }
    emit(ChangeAppThemeModeState());
  }

  Future<void> changeTheme(AppThemeMode mode) async {
    currentThemeMode = mode;
    await HiveHelper.addToHive(
      key: AppConstants.hiveDarkMode,
      value: mode.toString(),
    );
    emit(ChangeAppThemeModeState());
  }

  /// Helper getter if you still need a bool for dark mode
  bool get isDarkMode => currentThemeMode == AppThemeMode.dark;
}
