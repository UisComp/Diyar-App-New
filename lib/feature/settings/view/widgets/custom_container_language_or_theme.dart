import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainerLanguageOrTheme extends StatelessWidget {
  const CustomContainerLanguageOrTheme({
    super.key,
    required this.text,
    this.onTap,
    this.isSelected = false,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 120.w,
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.1)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyle.fontSize16Regular(context)
            
          ),
        ),
      ),
    );
  }
}
