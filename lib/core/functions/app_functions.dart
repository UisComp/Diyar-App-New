import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFunctions {
  static void successMessage(BuildContext context, {required String message}) {
    CherryToast.success(
      animationType: AnimationType.fromRight,
      toastPosition: Position.top,
      borderRadius: 12.r,
      displayCloseButton: true,
      backgroundColor: AppColors.greenColor,
      toastDuration: const Duration(seconds: 3),
      title: Text(
        message,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ).show(context);
  }

  static void errorMessage(
    BuildContext context, {
    required String message,
    String? description,
  }) {
    CherryToast.error(
      animationType: AnimationType.fromLeft,
      toastPosition: Position.top,
      borderRadius: 12.r,
      displayCloseButton: true,
      backgroundColor: AppColors.redColor,
      toastDuration: const Duration(seconds: 4),
      title: Text(
        message,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      description: description != null && description.isNotEmpty
          ? Text(
              description,
              style: TextStyle(color: AppColors.blackColor, fontSize: 12.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
    ).show(context);
  }
}
