import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyDottedBox extends StatelessWidget {
  const EmptyDottedBox({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(12.r),
        color: surface.textSecondary.withValues(alpha: 0.4),
        strokeWidth: 1,
        dashPattern: const [6, 3],
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 22.h),
        alignment: Alignment.center,
        child: AppText(
          LocaleKeys.no_documents_found.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            color: surface.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
