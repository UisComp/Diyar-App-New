import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlreadyHaveAccountWithSignIn extends StatelessWidget {
  const AlreadyHaveAccountWithSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLinkRow(
      prompt: LocaleKeys.already_have_account.tr(),
      action: LocaleKeys.sign_in.tr(),
      onTap: () =>
          context.canPop() ? context.pop() : context.go(RoutesName.login),
    );
  }
}
