import 'dart:async';

import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/helper/device_helper.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/routes/app_routes.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/model/login_response_model.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:diyar_app/feature/profile/service/profile_service.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// The signed-in account on this device.
abstract class AuthSession {
  static bool get isLoggedIn => userModel?.data?.accessToken != null;

  static bool get isGuard =>
      userModel?.data?.user.roles?.contains('guard') ?? false;

  /// Residents (unit owners) sign in with their phone number.
  static bool get isResident => isLoggedIn && !isGuard;

  /// Saves a new login. [identifier] and [password] are kept for biometric
  /// sign-in: the phone number for residents, the email for guards.
  static Future<void> start(
    LoginData data, {
    String? message,
    required String identifier,
    String? password,
  }) async {
    final model = LoginResponseModel(
      success: true,
      message: message,
      data: data,
    );
    await updateUserModel(model);
    await HiveHelper.addToHive(
      key: AppConstants.token,
      value: data.accessToken,
    );
    await HiveHelper.storeUserModel(model, AppConstants.userModelKey);
    if (password != null) {
      await savedCredentials(identifier: identifier, password: password);
    }
    // SMS and pushes use the language saved on the account.
    unawaited(syncLocale());
  }

  /// Forgets the login on this device (biometric credentials are kept).
  static Future<void> clear() async {
    await HiveHelper.removeFromHive(key: AppConstants.token);
    await updateUserModel(null);
    await HiveHelper.removeUserModel(key: AppConstants.userModelKey);
    await HiveHelper.clearUserDataOnly();
    await HiveHelper.removeFromHive(key: AppConstants.fcmToken);
  }

  static bool _expiring = false;

  /// The API rejected this device's token (`401`): forget the login and go
  /// back to the login screen. Several requests can fail at once, so this
  /// runs once.
  static Future<void> expire() async {
    if (_expiring || !isLoggedIn) return;
    _expiring = true;
    try {
      await clear();
      final context = router.routerDelegate.navigatorKey.currentContext;
      if (context == null || !context.mounted) return;
      HomeController.get(context).changeTab(AppTab.home);
      router.go(RoutesName.login);
      AppFunctions.warningMessage(
        context,
        message: LocaleKeys.session_expired_sign_in_again.tr(),
      );
    } finally {
      _expiring = false;
    }
  }

  /// The app's language code: `ar` or `en`.
  static Future<String> appLocale() async {
    final saved = await HiveHelper.getFromHive(
      key: AppConstants.myCurrentLanguagekey,
    );
    return saved == AppConstants.arLanguage
        ? AppConstants.arLanguage
        : AppConstants.enLanguage;
  }

  /// Tells the backend which language to use for this resident's SMS and
  /// pushes. Does nothing when signed out.
  static Future<void> syncLocale([String? locale]) async {
    if (!isLoggedIn) return;
    await ProfileService.updateLocale(locale ?? await appLocale());
  }

  /// Firebase rotated the token: replace this device's token only.
  static Future<void> onPushTokenRefreshed(String token) async {
    if (!isLoggedIn) return;
    await ProfileService.updateFcmToken(
      fcmToken: token,
      platform: DeviceHelper.platform,
    );
  }
}
