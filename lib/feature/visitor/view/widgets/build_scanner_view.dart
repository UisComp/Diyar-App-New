import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BuildScannerView extends StatefulWidget {
  const BuildScannerView({
    super.key,
    required this.visitorController,
    this.scannerController,
  });
  final VisitorController visitorController;
  final MobileScannerController? scannerController;

  @override
  State<BuildScannerView> createState() => _BuildScannerViewState();
}

class _BuildScannerViewState extends State<BuildScannerView> {
  bool isScanning = false;
  String? scannedCode;

  Future<void> onQrScanned(String code) async {
    if (!isScanning) return;
    stopScan();
    scannedCode = code;
    await widget.visitorController.scanQrCodeRequest(scannedCode);
  }

  Future<void> startScan() async {
    isScanning = true;
    await widget.scannerController?.start();
  }

  Future<void> stopScan() async {
    try {
      isScanning = false;
      await widget.scannerController?.stop();
      context.pop();
    } catch (e) {
      AppLogger.error("stopScan error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: widget.scannerController,
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final String? code = barcode.rawValue;

            if (code != null && code.contains('token=')) {
              AppLogger.log("Code: $code");
              isScanning = true;
              onQrScanned(code);
            }
          },
        ),
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Center(
            child: Container(
              width: 260.w,
              height: 260.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                LocaleKeys.align_barcode.tr(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              20.ph,
              CustomButton(
                buttonText: LocaleKeys.stop_scanning.tr(),
                onPressed: stopScan,
                buttonColor: AppColors.redColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
