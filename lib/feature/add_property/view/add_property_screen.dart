import 'package:diyar_app/core/widgets/coming_soon_view.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonView(
      title: LocaleKeys.add_property.tr(),
      icon: Icons.add_home_rounded,
    );
  }
}
