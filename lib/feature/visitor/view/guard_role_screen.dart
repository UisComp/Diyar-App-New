import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:diyar_app/feature/visitor/view/widgets/build_idle_view.dart';
import 'package:diyar_app/feature/visitor/view/widgets/build_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuardRoleScreen extends StatefulWidget {
  const GuardRoleScreen({super.key});

  @override
  State<GuardRoleScreen> createState() => _GuardRoleScreenState();
}

class _GuardRoleScreenState extends State<GuardRoleScreen>
    with SingleTickerProviderStateMixin {
  late VisitorController visitorController;
  @override
  void initState() {
    super.initState();
    visitorController = VisitorController.get(context);
  }

  @override
  void dispose() {
    visitorController.scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VisitorController, VisitorState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: visitorController.isScanning
                ? BuildScannerView(visitorController: visitorController)
                : BuildIdleView(visitorController: visitorController),
          );
        },
      ),
    );
  }
}
