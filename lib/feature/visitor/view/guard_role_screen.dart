import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class GuardRoleScreen extends StatefulWidget {
  const GuardRoleScreen({super.key});

  @override
  State<GuardRoleScreen> createState() => _GuardRoleScreenState();
}

class _GuardRoleScreenState extends State<GuardRoleScreen>
    with SingleTickerProviderStateMixin {
  bool isScanning = false;
  String? scannedCode;

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.itf,
      BarcodeFormat.pdf417,
    ],
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() => isScanning = true);
  }

  void _stopScan() {
    setState(() => isScanning = false);
    _scannerController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isScanning
            ? _buildScannerView(context)
            : _buildIdleView(context),
      ),
    );
  }

  Widget _buildIdleView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner_outlined,
              size: 120,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
            24.ph,
            Text(
              LocaleKeys.scan_barcode.tr(),
              style: AppStyle.fontSize22Bold(context),
              textAlign: TextAlign.center,
            ),
            12.ph,
            Text(
              LocaleKeys.position_barcode.tr(),
              style: AppStyle.fontSize16Regular(
                context,
              ).copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            32.ph,
            CustomButton(
              buttonText: LocaleKeys.scan.tr(),
              onPressed: _startScan,
              buttonColor: AppColors.primaryColor,
            ),
            if (scannedCode != null) ...[
              32.ph,
              Text(
                "Last scanned: $scannedCode",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            if (barcode.rawValue == null) return;
            _stopScan();
            setState(() => scannedCode = barcode.rawValue!);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Scanned: ${barcode.rawValue}"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Center(
            child: Container(
              width: 280,
              height: 180,
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
                onPressed: _stopScan,
                buttonColor: AppColors.redColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
