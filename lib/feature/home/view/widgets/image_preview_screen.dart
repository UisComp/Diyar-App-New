import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnnouncementImagePreviewScreen extends StatelessWidget {
  const AnnouncementImagePreviewScreen({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
  });
  final String? imageUrl;
  final String? title;
  final String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: "",
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(25.r),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black54Color,
                ),
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.whiteColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.whiteColor,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedNetworkImage(
                isProjectDetails: true,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
              20.ph,
              if (title != null && title!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 16.w,
                  ),
                  child: AppText(
                    title!.capitalize(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (description != null && description!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 20.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  child: AppText(
                    description!.capitalize(),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: AppColors.black87, fontSize: 14.sp),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
