import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/zoomable_image_viewer.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDeleteAccountDialog(
  BuildContext context, {
  void Function()? onDelete,
  bool isLoading = false,
}) async {
  await showGeneralDialog<Object?>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0, curvedValue * -50, 0)
          ..scale(animation.value),
        child: Opacity(
          opacity: animation.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: AppColors.containerColor,
            titlePadding: EdgeInsets.only(top: 24.h),
            title: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.redColor,
                  size: 48.w,
                ),
                12.ph,
                AppText(
                  LocaleKeys.delete_account.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 8.h,
            ),
            content: AppText(
              LocaleKeys.delete_account_desc.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 20.h, top: 10.h),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: AppColors.blackColor,
                      minimumSize: Size(110.w, 45.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: AppText(LocaleKeys.cancel.tr()),
                  ),
                  12.pw,
                  isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            minimumSize: Size(110.w, 45.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: onDelete,
                          child: AppText(
                            LocaleKeys.delete.tr(),
                            style: TextStyle(color: AppColors.containerColor),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens [imageUrl] full screen, zoomable. Kept as a function so the many
/// existing call sites stay put; the viewer itself lives in
/// [ZoomableImageViewer].
void showImagePreview(
  BuildContext context,
  String? imageUrl, {
  String? title,
  String? description,
  List<String?>? images,
  int initialIndex = 0,
}) {
  openImageViewer(
    context,
    images: images ?? [imageUrl],
    initialIndex: initialIndex,
    title: title,
    description: description,
  );
}

Future<void> showErrorDialog(
  BuildContext context, {
  required String message,
  String? title,
  void Function()? onRetry,
  bool isLoading = false,
}) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(0, curvedValue * -50, 0)
          ..scale(animation.value),
        child: Opacity(
          opacity: animation.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: AppColors.containerColor,
            titlePadding: EdgeInsets.only(top: 24.h),
            title: Column(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: AppColors.redColor,
                  size: 48.w,
                ),
                12.ph,
                AppText(
                  title ?? LocaleKeys.error.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 8.h,
            ),
            content: AppText(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 20.h, top: 10.h),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: AppColors.blackColor,
                      minimumSize: Size(110.w, 45.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: AppText(LocaleKeys.ok.tr()),
                  ),
                  if (onRetry != null) ...[
                    12.pw,
                    isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: Size(110.w, 45.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: onRetry,
                            child: AppText(
                              "Retry",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                          ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
