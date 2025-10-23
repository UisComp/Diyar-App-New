
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/view/widgets/empty_dotted_box.dart';
import 'package:diyar_app/feature/finance/view/widgets/file_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  const DocumentGroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final List files = group["files"];
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group["title"],
            style: AppStyle.fontSize18Bold(context)
                .copyWith(color: AppColors.primaryColor),
          ),
          10.ph,
          if (files.isEmpty)
            const EmptyDottedBox()
          else
            Column(
              children: List.generate(
                files.length,
                (i) => FileCard(file: Map<String, String>.from(files[i])),
              ),
            ),
        ],
      ),
    );
  }
}


