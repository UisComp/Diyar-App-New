import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = ProfileController.get(context);
    profileController.getMyProfile();
    profileController.getUserLinkedUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.profile.tr()),
      body: BlocBuilder<ProfileController, ProfileState>(
        builder: (context, state) {
          final isLoading = state is GetUserLinkedUnitsLoadingState ||
              state is GetMyProfileLoadingState;

          final profile = profileController.profileResponseModel.data;
          final linkedUnits = profileController.userLinkedUnitsResponseModel.data ?? [];

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    37.ph,
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.containerColor,
                      child: SvgPicture.asset(
                        Assets.images.svg.person,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                    10.ph,
                    Text(
                      profile?.name ?? 'Guest',
                      style: AppStyle.fontSize22Bold(context),
                    ),
                    5.ph,
                    Text(
                      profile?.email ?? '',
                      style: AppStyle.fontSize16Regular(context).copyWith(
                        color: AppColors.descContainerColor,
                      ),
                    ),
                    5.ph,
                    Text(
                      profile?.phoneNumber ?? '',
                      style: AppStyle.fontSize16Regular(context).copyWith(
                        color: AppColors.descContainerColor,
                      ),
                    ),
                    32.ph,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Linked Units",
                        style: AppStyle.fontSize22Bold(context).copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 16.w),
                    8.ph,
                    ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: isLoading ? 3 : linkedUnits.length,
                      separatorBuilder: (_, _) => 10.ph,
                      itemBuilder: (context, index) {
                        final unit = isLoading ? null : linkedUnits[index];
                        return CustomContainerInformation(
                          titleContainer: unit?.name ?? 'Loading...',
                          descriptionContainer:
                              "",
                          svgIcon: Assets.images.svg.home,
                          onTap: () {},
                        );
                      },
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
}
