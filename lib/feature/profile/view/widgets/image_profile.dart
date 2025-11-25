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

import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({super.key, required this.profile});

  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
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
          /// -----------------------------
          ///       PROFILE IMAGE
          /// -----------------------------
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.containerColor,
            child: (profile?.profilePicture?.url != null)
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

          SizedBox(height: 10.h),

          /// -----------------------------
          ///       USER INFO TEXT
          /// -----------------------------
          Text(
            profile?.name ?? 'Guest',
            style: AppStyle.fontSize22Bold(context),
          ),
          SizedBox(height: 5.h),
          Text(
            profile?.email ?? '',
            style: AppStyle.fontSize16Regular(
              context,
            ).copyWith(color: AppColors.descContainerColor),
          ),
          SizedBox(height: 5.h),
          Text(
            profile?.phoneNumber ?? '',
            style: AppStyle.fontSize16Regular(
              context,
            ).copyWith(color: AppColors.descContainerColor),
          ),
        ],
      ),
    );
  }
}
