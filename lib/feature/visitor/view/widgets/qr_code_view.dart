import 'dart:io';
import 'dart:ui';

import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/view/widgets/visitor_form_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({super.key, required this.visitorController});

  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    final bool darkTheme = VisitorFormTheme.isDark(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: VisitorFormTheme.surface(context),
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.25),
        ),
        boxShadow: darkTheme
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        children: [
          AppText(
            LocaleKeys.your_qr_code.tr(),
            style: AppStyle.fontSize16Bold(context),
          ),
          20.ph,
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(18.r)),
              border: Border.all(color: VisitorFormTheme.border(context)),
            ),
            child: QrImageView(
              data: visitorController.generatedQrData!,
              version: QrVersions.auto,
              size: 200.sp,
              backgroundColor: AppColors.whiteColor,
            ),
          ),
          20.ph,
          _ShareButton(visitorController: visitorController),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.visitorController});

  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.all(Radius.circular(14.r)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
        onTap: () => _shareQr(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.ios_share_rounded,
                size: 20.sp,
                color: AppColors.primaryColor,
              ),
              10.pw,
              AppText(
                LocaleKeys.share_qr_code.tr(),
                style: AppStyle.fontSize14Bold(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareQr(BuildContext context) async {
    try {
      final qrData = visitorController.generatedQrData!;

      final qrValidationResult = QrValidator.validate(
        data: qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final painter = QrPainter.withQr(
          qr: qrValidationResult.qrCode!,
          color: AppColors.blackColor,
          emptyColor: AppColors.whiteColor,
        );

        final tempDir = await getTemporaryDirectory();
        final file = File("${tempDir.path}/qr_code.png");

        final picData = await painter.toImageData(
          2048,
          format: ImageByteFormat.png,
        );
        await file.writeAsBytes(picData!.buffer.asUint8List());

        await Share.shareXFiles(
          [XFile(file.path)],
          subject: LocaleKeys.share_qr_code.tr(),
          text: LocaleKeys.invitation_code.tr(),
        );
      }
    } catch (e) {
      debugPrint("QR share error: $e");
    }
  }
}
