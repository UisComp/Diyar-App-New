import 'dart:io';
import 'dart:ui';

import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
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
    return Column(
      children: [
        Text(
          LocaleKeys.your_qr_code.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        16.ph,
        QrImageView(
          data: visitorController.generatedQrData!,
          version: QrVersions.auto,
          size: 200.sp,
          backgroundColor: Colors.white,
        ),
        20.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.share,
                color: AppColors.primaryColor,
                size: 28,
              ),
              tooltip: LocaleKeys.share_qr_code.tr(),
              onPressed: () async {
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
                      color: Colors.black,
                      emptyColor: Colors.white,
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
              },
            ),
            Text(
              LocaleKeys.share_qr_code.tr(),
              style: AppStyle.fontSize16Regular(context),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}
