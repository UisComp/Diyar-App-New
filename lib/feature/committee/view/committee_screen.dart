import 'package:diyar_app/core/widgets/coming_soon_view.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommitteeScreen extends StatelessWidget {
  const CommitteeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonView(
      title: LocaleKeys.committee.tr(),
      icon: Icons.groups_rounded,
    );
  }
}
