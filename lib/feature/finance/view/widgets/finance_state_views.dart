import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-height message used inside a scrollable (so pull-to-refresh works).
class FinanceMessageView extends StatelessWidget {
  const FinanceMessageView({
    super.key,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  const FinanceMessageView.error({super.key, this.onRetry})
    : icon = Icons.cloud_off_rounded,
      message = null;

  final IconData icon;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 72.sp,
                color: AppColors.primaryColor.withValues(alpha: 0.5),
              ),
              16.ph,
              Text(
                message ?? LocaleKeys.error_loading_finance.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, color: surface.textSecondary),
              ),
              if (onRetry != null) ...[
                16.ph,
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(LocaleKeys.try_again.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
