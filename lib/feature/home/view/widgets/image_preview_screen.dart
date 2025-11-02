import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({
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
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.whiteColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (imageUrl != null)
            Center(
              child: Hero(
                tag: imageUrl!,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 4,
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
                            child: Text(
                              title!.capitalize(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
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
                            child: Text(
                              description!.capitalize(),
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
            ),

          /// CLOSE BUTTON
          // Positioned(
          //   top: 50.h,
          //   right: 20.w,
          //   child: AnimatedOpacity(
          //     opacity: 1,
          //     duration: const Duration(milliseconds: 500),
          //     child: InkWell(
          //       borderRadius: BorderRadius.circular(50.r),
          //       onTap: () => Navigator.pop(context),
          //       child: Container(
          //         padding: EdgeInsets.all(8.w),
          //         decoration: const BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.black54,
          //         ),
          //         child: Icon(
          //           Icons.close_rounded,
          //           color: AppColors.whiteColor,
          //           size: 30.sp,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
