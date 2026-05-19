import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({super.key, required this.profile});

  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeController, AppThemeState>(
      builder: (context, state) {
        final darkTheme =
            AppThemeController.get(context).currentThemeMode ==
            AppThemeMode.dark;
        final cardColor = darkTheme ? const Color(0xFF111418) : AppColors.whiteColor;
        final borderColor =
            darkTheme ? const Color(0xFF1F242B) : const Color(0xFFE5E9F0);
        final textColor = darkTheme
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: darkTheme
                ? null
                : [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  gradient: AppColors.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.12),
                  child:
                      (profile?.profilePicture?.url != null &&
                          userModel?.data?.accessToken != null)
                      ? ClipOval(
                          child: CustomCachedNetworkImage(
                            imageUrl:
                                '${profile!.profilePicture!.url!}?v=${DateTime.now().millisecondsSinceEpoch}',
                            width: 96.r,
                            height: 96.r,
                            fit: BoxFit.cover,
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.images.svg.person,
                          width: 46.w,
                          height: 46.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
              10.ph,
              AppText(
                userModel?.data?.accessToken == null
                    ? LocaleKeys.guest.tr()
                    : profile?.name ?? '',
                style: AppStyle.fontSize22Bold(context).copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (userModel?.data?.accessToken != null) ...[
                6.ph,
                AppText(
                  profile?.email ?? '',
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 13.sp,
                  ),
                ),
                3.ph,
                AppText(
                  profile?.phoneNumber ?? '',
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
