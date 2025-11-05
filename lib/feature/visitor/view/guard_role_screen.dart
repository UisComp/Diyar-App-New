import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/feature/settings/functions/settings_functions.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:diyar_app/feature/visitor/view/widgets/build_idle_view.dart';
import 'package:diyar_app/feature/visitor/view/widgets/build_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class GuardRoleScreen extends StatefulWidget {
  const GuardRoleScreen({super.key, this.visitorController});
  final VisitorController? visitorController;
  @override
  State<GuardRoleScreen> createState() => _GuardRoleScreenState();
}

class _GuardRoleScreenState extends State<GuardRoleScreen>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController scannerController;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.normal,
      formats: const [
        BarcodeFormat.qrCode,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.dataMatrix,
        BarcodeFormat.itf,
        BarcodeFormat.pdf417,
        BarcodeFormat.codabar,
        BarcodeFormat.upcA,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VisitorController, VisitorState>(
        listener: (context, visitorState) {
          if (visitorState is ScanQrRequestLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (visitorState is ScanQrRequestSuccessState) {
            Navigator.pop(context);
            AppFunctions.successMessage(
              context,
              message: "QR scanned successfully",
            );
          }
          if (visitorState is ScanQrRequestErrorState) {
            Navigator.pop(context);
            showErrorDialog(context, message: visitorState.message!);
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: BuildScannerView(
              visitorController: widget.visitorController!,
              scannerController: scannerController,
            ),
            // : BuildIdleView(visitorController: widget.visitorController!),
          );
        },
      ),
    );
  }
}
