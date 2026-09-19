import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// After any successful login: load the new account's notifications and
/// open home.
void goHomeAfterSignIn(BuildContext context, {String? message}) {
  try {
    NotificationController.get(
      context,
    ).fetchAllNotifications(refresh: true, page: 1);
  } catch (e) {
    AppLogger.warning('Could not refresh notifications after login: $e');
  }
  AppFunctions.successMessage(
    context,
    message: message ?? LocaleKeys.login_successfully.tr(),
  );
  context.go(RoutesName.homeLayout);
}
