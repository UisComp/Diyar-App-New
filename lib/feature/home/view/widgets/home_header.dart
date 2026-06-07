import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/notifications/controller/notification_cubit.dart';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Dashboard-style greeting header for Home: time-based greeting, the signed-in
/// user's first name, an avatar, and the notification bell with unread badge.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.darkTheme});

  final bool darkTheme;

  String get _greetingKey {
    final hour = DateTime.now().hour;
    if (hour < 12) return LocaleKeys.good_morning;
    if (hour < 17) return LocaleKeys.good_afternoon;
    return LocaleKeys.good_evening;
  }

  String _firstName() {
    final fullName = userModel?.data?.user.name.trim();
    if (fullName == null || fullName.isEmpty) return LocaleKeys.guest.tr();
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = userModel?.data?.accessToken == null;
    final name = isGuest ? LocaleKeys.guest.tr() : _firstName();

    return Row(
      children: [
        _avatar(name, isGuest),
        12.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                _greetingKey.tr(),
                style: AppStyle.fontSize12Regular(context).copyWith(
                  fontSize: 12.sp,
                  color: AppColors.descContainerColor,
                ),
                maxLines: 1,
              ),
              2.ph,
              AppText(
                name,
                style: AppStyle.fontSize18Bold(context).copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _NotificationBell(darkTheme: darkTheme),
      ],
    ).paddingSymmetric(horizontal: 16.w, vertical: 8.h);
  }

  Widget _avatar(String name, bool isGuest) {
    return Container(
      height: 46.w,
      width: 46.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isGuest
          ? Icon(Icons.person_outline_rounded, color: AppColors.whiteColor, size: 24.sp)
          : AppText(
              name.characters.first.toUpperCase(),
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

/// Notification bell with an unread-count badge, extracted from the old app bar.
class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.darkTheme});

  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationController, NotificationState>(
      builder: (context, state) {
        final controller = NotificationController.get(context);
        final isLoading = state is NotificationLoading;
        final isGuest = userModel?.data?.accessToken == null;
        final unread =
            controller.notifications?.data?.unreadNotificationsCount ?? 0;

        return Material(
          color: darkTheme
              ? AppColors.white12Color
              : AppColors.primaryColor.withValues(alpha: 0.06),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              if (isGuest) {
                AppFunctions.warningMessage(
                  context,
                  message: LocaleKeys
                      .notifications_for_logged_in_users_only
                      .tr(),
                );
                return;
              }
              if (!isLoading) {
                context.push(RoutesName.notificationsScreen);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  isLoading
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.images.svg.notification,
                          height: 22.h,
                          width: 22.w,
                          colorFilter: ColorFilter.mode(
                            isGuest
                                ? AppColors.greyColor
                                : darkTheme
                                    ? AppColors.whiteColor
                                    : AppColors.black87,
                            BlendMode.srcIn,
                          ),
                        ),
                  if (!isGuest && !isLoading && unread > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: EdgeInsets.all(2.sp),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: darkTheme
                                ? AppColors.darkBackground
                                : AppColors.whiteColor,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: AppText(
                          unread > 99 ? '99+' : '$unread',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
