import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows why a login or registration step failed. Problems with the
/// account itself open a dialog that offers the way forward; anything else
/// is a toast.
///
/// Returns true for account problems: this number can't go further here.
bool showAuthError(
  BuildContext context,
  ApiResult<dynamic> result, {
  String? phone,
}) {
  final message = apiErrorMessage(result);
  switch (result.errorCode) {
    case ApiErrorCodes.phoneNotRegistered:
      showAuthActionDialog(
        context,
        title: LocaleKeys.not_registered_title.tr(),
        message: message,
        actionText: LocaleKeys.sign_up.tr(),
        onAction: () => context.push(RoutesName.register, extra: phone),
      );
      return true;
    case ApiErrorCodes.useEmailLogin:
    case ApiErrorCodes.usePhoneLogin:
      // Wrong kind of login for this account: say which one to use.
      showAuthActionDialog(
        context,
        title: LocaleKeys.sign_in.tr(),
        message: message,
      );
      return true;
    case ApiErrorCodes.phoneAlreadyRegistered:
      showAuthActionDialog(
        context,
        title: LocaleKeys.sign_in.tr(),
        message: message,
        actionText: LocaleKeys.sign_in.tr(),
        onAction: () => context.go(RoutesName.login),
      );
      return true;
    case ApiErrorCodes.accountPending:
    case ApiErrorCodes.registrationPending:
      showAuthActionDialog(
        context,
        title: LocaleKeys.registration_pending_title.tr(),
        message: message,
      );
      return true;
    case ApiErrorCodes.notAllowed:
    case ApiErrorCodes.registrationPaused:
      AppFunctions.errorMessage(context, message: message);
      return true;
    default:
      AppFunctions.errorMessage(context, message: message);
      return false;
  }
}
