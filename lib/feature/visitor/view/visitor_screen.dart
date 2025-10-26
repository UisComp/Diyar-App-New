import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/visitor/view/guard_role_screen.dart';
import 'package:diyar_app/feature/visitor/view/own_unit_screen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VisitorScreen extends StatelessWidget {
  const VisitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.visitor.tr()),
      body:OwnUnitScreen() 
      // const GuardRoleScreen(),
    );
  }
}
