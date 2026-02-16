// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
// import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
// import 'package:diyar_app/gen/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class ImageProfile extends StatelessWidget {
//   const ImageProfile({
//     super.key,
//     required this.profile,
//   });

//   final ProfileData? profile;

//   @override
//   Widget build(BuildContext context) {
//     return
//     // CircleAvatar(
//     //   radius: 50.r,
//     //   backgroundColor: AppColors.containerColor,
//     //   child: (profile?.profilePicture?.url != null)
//     //       ? ClipOval(
//     //           child: CustomCachedNetworkImage(
//     //             imageUrl:
//     //                 '${profile!.profilePicture!.url!}?v=${DateTime.now().millisecondsSinceEpoch}',
//     //             width: 100.r,
//     //             height: 100.r,
//     //             fit: BoxFit.cover,
//     //           ),
//     //         )
//     //       : SvgPicture.asset(
//     //           Assets.images.svg.person,

//     //           width: 50.w,
//     //           height: 50.h,
//     //         ),
//     // );
//  Container(
//     padding: EdgeInsets.all(20.r),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(24.r),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black12,
//           blurRadius: 10,
//           offset: Offset(0, 3),
//         )
//       ],
//     ),
//     child: Column(
//       children: [
//         ImageProfile(profile: profile),
//         SizedBox(height: 10.h),
//         Text(
//           profile?.name ?? 'Guest',
//           style: AppStyle.fontSize22Bold(context),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           profile?.email ?? '',
//           style: AppStyle.fontSize16Regular(context)
//               .copyWith(color: AppColors.descContainerColor),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           profile?.phoneNumber ?? '',
//           style: AppStyle.fontSize16Regular(context)
//               .copyWith(color: AppColors.descContainerColor),
//         ),
//       ],
//     ),
//   );
//   }
// }

import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
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
        final cardColor = darkTheme ? AppColors.black87 : AppColors.whiteColor;
        final cardImageColor = darkTheme
            ? AppColors.black87
            : AppColors.secondaryColor;
        final textColor = darkTheme
            ? AppColors.containerColor
            : AppColors.black87;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: cardImageColor,
                child: (profile?.profilePicture?.url != null && userModel?.data?.accessToken != null)
                    ? ClipOval(
                        child: CustomCachedNetworkImage(
                          imageUrl:
                              '${profile!.profilePicture!.url!}?v=${DateTime.now().millisecondsSinceEpoch}',
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SvgPicture.asset(
                        Assets.images.svg.person,
                        width: 50.w,
                        height: 50.h,
                      ),
              ),
              10.ph,
              Text(
                userModel?.data?.accessToken == null
                    ? LocaleKeys.guest.tr()
                    : profile?.name ?? '',
                style: AppStyle.fontSize22Bold(
                  context,
                ).copyWith(color: textColor),
              ),
              5.ph,
              if (userModel?.data?.accessToken != null)
                Text(
                  profile?.email ?? '',
                  style: AppStyle.fontSize16Regular(
                    context,
                  ).copyWith(color: AppColors.descContainerColor),
                ),
              if (userModel?.data?.accessToken != null) ...[
                5.ph,
                Text(
                  profile?.phoneNumber ?? '',
                  style: AppStyle.fontSize16Regular(
                    context,
                  ).copyWith(color: AppColors.descContainerColor),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
