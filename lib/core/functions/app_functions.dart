import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFunctions {
  static void successMessage(BuildContext context, {required String message}) {
    CherryToast.success(
      height: 60.h,
      borderRadius: 10.r,
      animationType: AnimationType.fromRight,
      displayCloseButton: true,
      backgroundColor: AppColors.greenColor,
      title: Text(message, style: TextStyle(color: AppColors.blackColor)),
    ).show(context);
  }

  static void errorMessage(BuildContext context, {required String message}) {
    CherryToast.error(
      height: 60.h,
      animationType: AnimationType.fromRight,
      borderRadius: 10.r,

      displayCloseButton: true,
      title: Text(message, style: TextStyle(color: AppColors.blackColor)),
    ).show(context);
  }
}