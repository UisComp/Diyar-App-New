import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/view/guard_role_screen.dart';
import 'package:diyar_app/feature/visitor/view/own_unit_screen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  late bool isOwnUnit;
  @override
  void initState() {
    super.initState();

    if (userModel!.data != null &&
        userModel!.data!.user.roles != null &&
        userModel!.data!.user.roles!.isNotEmpty) {
      isOwnUnit = userModel!.data!.user.roles!.contains("user");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.visitor.tr(),
      ),
      body: isOwnUnit
          ? const OwnUnitScreen()
          : GuardRoleScreen(visitorController: VisitorController.get(context)),
    );
  }
}
