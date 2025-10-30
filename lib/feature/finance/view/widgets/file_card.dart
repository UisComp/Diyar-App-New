import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/documents_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileCard extends StatelessWidget {
  final DocumentFile file;
  const FileCard({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      builder: (context, state) {
        String formatFileSize(int bytes) {
          if (bytes < 1024) {
            return "$bytes B";
          } else if (bytes < 1024 * 1024) {
            double kb = bytes / 1024;
            return "${kb.toStringAsFixed(2)} KB";
          } else {
            double mb = bytes / (1024 * 1024);
            return "${mb.toStringAsFixed(2)} MB";
          }
        }

        final bool isPreviewLoading = state.maybeWhen(
          previewFileLoading: () => true,
          orElse: () => false,
        );

        final bool isDownloadLoading = state.maybeWhen(
          downloadFileLoading: () => true,
          orElse: () => false,
        );
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      file.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: isPreviewLoading
                            ? null
                            : () async {
                                await context
                                    .read<FinanceController>()
                                    .previewFile(file.url!);
                              },
                        icon: Icon(
                          Icons.visibility,
                          color: isPreviewLoading
                              ? AppColors.greyColor
                              : AppColors.blueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: isDownloadLoading
                            ? null
                            : () async {
                                await context
                                    .read<FinanceController>()
                                    .downloadFile(file.url!);
                              },
                        icon: Icon(
                          Icons.download,
                          color: isDownloadLoading
                              ? AppColors.greyColor
                              : AppColors.greenColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              4.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${LocaleKeys.date.tr()}: ${file.uploadedAt?.split('T').first ?? ''}",
                  ),
                  Text(
                    "${LocaleKeys.size.tr()}: ${formatFileSize(int.tryParse(file.size ?? '0') ?? 0)}",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
