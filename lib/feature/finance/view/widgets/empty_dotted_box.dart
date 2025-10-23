
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyDottedBox extends StatelessWidget {
  const EmptyDottedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
   options: RectDottedBorderOptions(
      color: Colors.grey,
      strokeWidth: 1,
      dashPattern: [6, 3],
   ), 
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        color: Colors.grey.shade50,
        alignment: Alignment.center,
        child: Text(
          LocaleKeys.no_documents_found.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
