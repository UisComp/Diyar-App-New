import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
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
                Text(
                  LocaleKeys.delete_account.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 8.h,
            ),
            content: Text(
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
                    child: Text(LocaleKeys.cancel.tr()),
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
                          child: Text(
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
void showImagePreview(
  BuildContext context,
  String imageUrl, {
  String? title,
  String? description,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ImagePreview',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: imageUrl,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CustomCachedNetworkImage(
                        isProjectDetails: true,
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                      ),
                      20.ph,
                      if (title != null && title.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 16.w,
                          ),
                          child: Text(
                            title.capitalize(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      if (description != null && description.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 20.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Text(
                            description.capitalize(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            /// CLOSE BUTTON
            Positioned(
              top: 50.h,
              right: 20.w,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.whiteColor,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}
