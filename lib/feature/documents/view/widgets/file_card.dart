import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/documents/controller/documents_controller.dart';
import 'package:diyar_app/feature/documents/controller/documents_state.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileCard extends StatelessWidget {
  final DocumentFile file;
  const FileCard({super.key, required this.file});

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  IconData get _icon {
    final name = (file.name ?? file.url ?? '').toLowerCase();
    final mime = (file.mimeType ?? '').toLowerCase();
    if (mime.contains('pdf') || name.endsWith('.pdf')) {
      return Icons.picture_as_pdf_outlined;
    }
    if (mime.startsWith('image/') ||
        RegExp(r'\.(png|jpe?g|webp|heic)$').hasMatch(name)) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final url = file.url;

    return BlocBuilder<DocumentsController, DocumentsState>(
      buildWhen: (previous, current) =>
          current is PreviewFileLoadingState ||
          current is PreviewFileSuccessState ||
          current is PreviewFileFailureState ||
          current is DownloadFileProgressState ||
          current is DownloadFileSuccessState ||
          current is DownloadFileFailureState,
      builder: (context, state) {
        final isPreviewing =
            state is PreviewFileLoadingState && state.fileUrl == url;
        final progress =
            state is DownloadFileProgressState && state.fileUrl == url
            ? state.progress
            : null;
        final uploadedAt = file.uploadedAt?.split('T').first ?? '';

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: surface.subtle,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: surface.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(_icon, color: AppColors.primaryColor, size: 26.sp),
                  10.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          file.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: surface.textPrimary,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        2.ph,
                        AppText(
                          [
                            if (uploadedAt.isNotEmpty) uploadedAt,
                            if (file.size != null) formatFileSize(file.size!),
                          ].join('  •  '),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: surface.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (url != null) ...[
                    isPreviewing
                        ? _ActionSpinner()
                        : IconButton(
                            tooltip: LocaleKeys.preview.tr(),
                            onPressed: () => context
                                .read<DocumentsController>()
                                .previewFile(url),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                    progress != null
                        ? _ActionSpinner(value: progress / 100)
                        : IconButton(
                            tooltip: LocaleKeys.download.tr(),
                            onPressed: () => context
                                .read<DocumentsController>()
                                .downloadFileWithProgress(url),
                            icon: const Icon(
                              Icons.download_rounded,
                              color: AppColors.greenColor,
                            ),
                          ),
                  ],
                ],
              ),
              if (progress != null) ...[
                6.ph,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    color: AppColors.primaryColor,
                    backgroundColor: surface.border,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ActionSpinner extends StatelessWidget {
  const _ActionSpinner({this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Center(
        child: SizedBox(
          width: 22.r,
          height: 22.r,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            value: value,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
