
// import 'package:diyar_app/core/extension/sized_box.dart';
// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:diyar_app/core/widgets/custom_button.dart';
// import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
// import 'package:diyar_app/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class BuildIdleView extends StatelessWidget {
//   const BuildIdleView({super.key, required this.visitorController});
//   final VisitorController visitorController;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.document_scanner_outlined,
//               size: 120,
//               color: Theme.of(context).primaryColor.withOpacity(0.8),
//             ),
//             24.ph,
//             Text(
//               LocaleKeys.scan_barcode.tr(),
//               style: AppStyle.fontSize22Bold(context),
//               textAlign: TextAlign.center,
//             ),
//             12.ph,
//             Text(
//               LocaleKeys.position_barcode.tr(),
//               style: AppStyle.fontSize16Regular(
//                 context,
//               ).copyWith(color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),
//             32.ph,
//             CustomButton(
//               buttonText: LocaleKeys.scan.tr(),
//               onPressed: visitorController.startScan,
//               buttonColor: AppColors.primaryColor,
//             ),
//             if (visitorController.scannedCode != null) ...[
//               32.ph,
//               Text(
//                 "Last scanned: ${visitorController.scannedCode}",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[700], fontSize: 15),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
