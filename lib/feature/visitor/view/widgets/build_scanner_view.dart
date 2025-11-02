import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BuildScannerView extends StatelessWidget {
  const BuildScannerView({super.key, required this.visitorController});
  final VisitorController visitorController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: visitorController.scannerController,
          // onDetect: (capture) {
          //   final barcode = capture.barcodes.first;
          //   if (barcode.rawValue == null) return;
          //   visitorController.stopScan();
          //   visitorController.scannedCode = barcode.rawValue!;
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text("Scanned: ${barcode.rawValue}"),
          //       behavior: SnackBarBehavior.floating,
          //     ),
          //   );
          // },
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final value = barcode.rawValue;

            if (value == null) return;

            visitorController.scannedCode = value;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Scanned: $value"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            visitorController.stopScan();
          },
        ),
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Center(
            child: Container(
              width: 260.w,
              height: 260.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                onPressed: visitorController.stopScan,
                buttonColor: AppColors.redColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
