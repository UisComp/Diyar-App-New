import 'package:diyar_app/core/widgets/coming_soon_view.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddTenantScreen extends StatelessWidget {
  const AddTenantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonView(
      title: LocaleKeys.add_tenant.tr(),
      icon: Icons.person_add_alt_1_rounded,
    );
  }
}
