import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Entry point from the profile to the customer's attachments
/// (contract, payment plan, engineering drawings, other files).
class ProfileDocumentsTile extends StatelessWidget {
  const ProfileDocumentsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => context.push(RoutesName.documentsScreen),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: surface.cardDecoration(),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.folder_copy_outlined,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.my_documents.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: surface.textPrimary,
                      ),
                    ),
                    2.ph,
                    Text(
                      LocaleKeys.my_documents_desc.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: surface.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              8.pw,
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                size: 22.sp,
                color: AppColors.primaryColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
