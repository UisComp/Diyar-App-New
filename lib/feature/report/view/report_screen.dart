import 'package:diyar_app/core/widgets/coming_soon_view.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonView(
      title: LocaleKeys.report.tr(),
      icon: Icons.assessment_rounded,
    );
  }
}
