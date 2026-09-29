import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccountWithSignUp extends StatelessWidget {
  const DontHaveAccountWithSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    // context.tr (not .tr()) so a language switch rebuilds this even
    // when it's built const.
    return AuthLinkRow(
      prompt: context.tr(LocaleKeys.donnot_have_account),
      action: context.tr(LocaleKeys.sign_up),
      onTap: () => context.push(RoutesName.register),
    );
  }
}
