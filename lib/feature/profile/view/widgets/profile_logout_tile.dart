import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Log-out row at the bottom of the profile. Asks for confirmation first,
/// then returns the app to Home so the next sign-in doesn't land on Profile.
class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthController(),
      child: BlocConsumer<AuthController, AuthState>(
        listener: (context, state) {
          final message = context
              .read<AuthController>()
              .logoutResponseModel
              .message;
          if (state is LogOutSuccessState) {
            AppFunctions.successMessage(
              context,
              message: message ?? LocaleKeys.logout_successfully.tr(),
            );
            HomeController.get(context).changeTab(AppTab.home);
            context.go(RoutesName.login);
          }
          if (state is LogOutFailureState) {
            AppFunctions.errorMessage(
              context,
              message: message ?? LocaleKeys.logout_failure.tr(),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LogOutLoadingState;
          final surface = AppSurface.of(context);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: isLoading ? null : () => _confirmLogout(context),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: surface.cardDecoration(
                  borderColor: AppColors.redColor.withValues(alpha: 0.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.redColor,
                              ),
                            )
                          : Icon(
                              Icons.logout_rounded,
                              color: AppColors.redColor,
                              size: 20.sp,
                            ),
                    ),
                    14.pw,
                    Expanded(
                      child: Text(
                        LocaleKeys.logout.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.redColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final surface = AppSurface.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surface.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          LocaleKeys.logout_confirm_title.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: surface.textPrimary,
          ),
        ),
        content: Text(
          LocaleKeys.logout_confirm_message.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.4,
            color: surface.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: TextStyle(color: surface.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(LocaleKeys.logout.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthController>().logOut();
    }
  }
}
