import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';
import 'package:diyar_app/feature/documents/view/widgets/empty_dotted_box.dart';
import 'package:diyar_app/feature/documents/view/widgets/file_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentGroupCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<DocumentFile> files;

  const DocumentGroupCard({
    super.key,
    required this.title,
    required this.icon,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: surface.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 20.sp, color: AppColors.primaryColor),
              ),
              10.pw,
              Expanded(
                child: AppText(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: surface.textPrimary,
                  ),
                ),
              ),
              if (files.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AppText(
                    '${files.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          12.ph,
          if (files.isEmpty)
            const EmptyDottedBox()
          else
            ...files.map((file) => FileCard(file: file)),
        ],
      ),
    );
  }
}
