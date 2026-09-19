import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Registration, step 4: the account waits for staff approval. The resident
/// gets an SMS, then does a normal first login (code → set password).
class RegistrationPendingScreen extends StatelessWidget {
  const RegistrationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RoutesName.login);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 96.r,
                          height: 96.r,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.hourglass_top_rounded,
                            size: 48.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        28.ph,
                        AppText(
                          LocaleKeys.registration_pending_title.tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize22Bold(
                            context,
                          ).copyWith(color: surface.textPrimary),
                        ),
                        12.ph,
                        AppText(
                          LocaleKeys.registration_pending_message.tr(),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize14Regular(
                            context,
                          ).copyWith(color: surface.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomButton(
                buttonHeight: 52.h,
                buttonText: LocaleKeys.back_to_sign_in.tr(),
                buttonColor: AppColors.primaryColor,
                onPressed: () => context.go(RoutesName.login),
              ).paddingAll(16.sp),
              const DesignedByFooter(compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
