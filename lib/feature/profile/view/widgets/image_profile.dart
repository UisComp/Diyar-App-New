
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({
    super.key,
    required this.profile,
  });

  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
    );
  }
}