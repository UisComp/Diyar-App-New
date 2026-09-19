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
    return AuthLinkRow(
      prompt: LocaleKeys.donnot_have_account.tr(),
      action: LocaleKeys.sign_up.tr(),
      onTap: () => context.push(RoutesName.register),
    );
  }
}
