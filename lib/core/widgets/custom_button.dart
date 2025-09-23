
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonColor,
    this.textColor,
    required this.buttonText,
    required this.onPressed,
    this.buttonHeight,
  });
  final Color? buttonColor;
  final Color? textColor;
  final String buttonText;
  final double? buttonHeight;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      height: buttonHeight ?? 48.h,
      minWidth: double.infinity,
      onPressed: onPressed,
      color: buttonColor ?? AppColors.secondaryColor,
      child: Text(
        buttonText,
        style: AppStyle.fontSize16Regular.copyWith(
          color: textColor ?? AppColors.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
