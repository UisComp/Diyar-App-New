import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/custom_logger.dart';

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

void goToDeviceSettings(BuildContext context) async {
  final Uri iosSettings = Uri.parse('app-settings:');
  try {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final intent = AndroidIntent(
        action: 'android.settings.SECURITY_SETTINGS',
      );
      await intent.launch();
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      if (!await launchUrl(iosSettings)) {
        throw 'Could not launch device settings.';
      }
    } else {
      throw 'Unsupported platform.';
    }
  } catch (e) {
    AppLogger.error('Error opening device settings: $e');
  }
}

void showLockRequiredDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          LocaleKeys.biometric.tr().toUpperCase(),
          textAlign: TextAlign.center,
        ),
        content: Text(
          LocaleKeys.enableDeviceLockInSettings.tr(),
          textAlign: TextAlign.center,
          style: AppStyle.fontSize18Bold(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              goToDeviceSettings(context);
            },
            child: Text(
              LocaleKeys.settings.tr(),
              style: AppStyle.fontSize18Bold(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool?> showConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.lightCard,
        title: Center(child: Text(LocaleKeys.biometric.tr().toUpperCase())),
        content: Text(
          LocaleKeys.enableBiometricTextInDialog.tr(),
          textAlign: TextAlign.center,
          style: AppStyle.fontSize16Regular(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: Text(
              LocaleKeys.cancel.tr(),
              style: TextStyle(color: AppColors.redColor, fontSize: 15.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: Text(
              LocaleKeys.setup.tr(),
              style: TextStyle(color: AppColors.primaryColor, fontSize: 15.sp),
            ),
          ),
        ],
      );
    },
  );
}
