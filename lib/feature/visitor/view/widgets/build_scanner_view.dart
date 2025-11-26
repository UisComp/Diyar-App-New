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
  bool _isProcessing = false;
  bool _hasScanned = false;
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with optimized settings
    _controller =
        widget.scannerController ??
        MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
          torchEnabled: false,
        );
  }

  @override
  void dispose() {
    // Only dispose if we created the controller
    if (widget.scannerController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onQrScanned(String code) async {
    // Prevent multiple scans
    if (_isProcessing || _hasScanned) return;

    setState(() {
      _isProcessing = true;
      _hasScanned = true;
    });

    try {
      AppLogger.log("Processing QR code: $code");

      // Stop scanner immediately to prevent additional scans
      await _controller.stop();

      // Process the QR code
      await widget.visitorController.scanQrCodeRequest(code);

      // Navigate back if still mounted
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      AppLogger.error("Error processing QR code: $e");

      // Re-enable scanning on error
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _hasScanned = false;
        });
        await _controller.start();
      }
    }
  }

  Future<void> _stopScan() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _controller.stop();
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      AppLogger.error("Error stopping scanner: $e");
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (capture) {
            // Return early if already processing
            if (_isProcessing || _hasScanned) return;

            final List<Barcode> barcodes = capture.barcodes;

            // Check if we have any barcodes
            if (barcodes.isEmpty) return;

            final String? code = barcodes.first.rawValue;

            // Validate code
            if (code != null && code.isNotEmpty && code.contains('token=')) {
              AppLogger.log("QR Code detected: $code");
              _onQrScanned(code);
            }
          },
        ),

        // Overlay with scanning area
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: Center(
            child: Container(
              width: 260.w,
              height: 260.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isProcessing ? Colors.green : Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: (_isProcessing ? Colors.green : Colors.white)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Corner indicators for better UX
        Center(
          child: SizedBox(
            width: 260.w,
            height: 260.h,
            child: Stack(
              children: [
                // Top-left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: _buildCorner(Alignment.topLeft),
                ),
                // Top-right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildCorner(Alignment.topRight),
                ),
                // Bottom-left corner
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _buildCorner(Alignment.bottomLeft),
                ),
                // Bottom-right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildCorner(Alignment.bottomRight),
                ),
              ],
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              if (_isProcessing)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      10.pw,
                      Text(
                        LocaleKeys.processing
                            .tr(), // Add this key to your locale
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  LocaleKeys.align_barcode.tr(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              20.ph,
              CustomButton(
                buttonText: LocaleKeys.stop_scanning.tr(),
                onPressed: _isProcessing ? null : _stopScan,
                buttonColor: _isProcessing
                    ? AppColors.redColor.withOpacity(0.5)
                    : AppColors.redColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        border: Border(
          top: alignment == Alignment.topLeft || alignment == Alignment.topRight
              ? BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          bottom:
              alignment == Alignment.bottomLeft ||
                  alignment == Alignment.bottomRight
              ? BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          left:
              alignment == Alignment.topLeft ||
                  alignment == Alignment.bottomLeft
              ? BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          right:
              alignment == Alignment.topRight ||
                  alignment == Alignment.bottomRight
              ? BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
