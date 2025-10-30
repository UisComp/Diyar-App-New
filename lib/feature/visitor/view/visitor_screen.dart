// import 'package:diyar_app/core/widgets/custom_app_bar.dart';
// import 'package:diyar_app/feature/visitor/view/guard_role_screen.dart';
// import 'package:diyar_app/feature/visitor/view/own_unit_screen.dart';
// import 'package:diyar_app/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class VisitorScreen extends StatelessWidget {
//   const VisitorScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(titleAppBar: LocaleKeys.visitor.tr(),isOtherIcon: true,otherIcon: ,),
//       body:OwnUnitScreen()
//       // const GuardRoleScreen(),
//     );
//   }
// }
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
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
  bool isOwnUnit = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showIconNotification: true,
        titleAppBar: LocaleKeys.visitor.tr(),
        isOtherIcon: true,
        otherIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: isOwnUnit,
                onChanged: (value) {
                  setState(() {
                    isOwnUnit = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: isOwnUnit ? const OwnUnitScreen() : const GuardRoleScreen(),
    );
  }
}
