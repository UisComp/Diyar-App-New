import 'dart:developer';

import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
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
    initProfileAndLinkedUnits();
  }

  Future<void> initProfileAndLinkedUnits() async {
    await profileController.getMyProfile();
    await profileController.getUserLinkedUnits();
  }

  @override
  void didChangeDependencies() {
    initProfileAndLinkedUnits();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    log("Helpppp");
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.profile.tr()),
      body: BlocConsumer<ProfileController, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          log(
            "at build in Profile profileResponseModel: ${profileController.profileResponseModel.toJson()}",
          );
          final isLoading =
              state is GetUserLinkedUnitsLoadingState ||
              state is GetMyProfileLoadingState;

          final profile = profileController.profileResponseModel.data;
          final linkedUnits =
              profileController.userLinkedUnitsResponseModel.data ?? [];
          log("profileController.image ${profileController.image}");
          log("profile?.profilePicture?.url ${profile?.profilePicture?.url}");
          return Skeletonizer(
            enabled: isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.ph,
                  BlocBuilder<ProfileController, ProfileState>(
                    builder: (context, state) {
                      return CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.containerColor,
                        child: profileController.image != null
                            ? ClipOval(
                                child: Image.file(
                                  profileController.image!,
                                  width: 100.r,
                                  height: 100.r,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (profile?.profilePicture?.url != null
                                  ? ClipOval(
                                      child: CustomCachedNetworkImage(
                                        imageUrl: profile!.profilePicture!.url!,
                                        width: 100.r,
                                        height: 100.r,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      Assets.images.svg.person,
                                      width: 50.w,
                                      height: 50.h,
                                    )),
                      );
                    },
                  ),

                  10.ph,
                  Text(
                    profile?.name ?? 'Guest',
                    style: AppStyle.fontSize22Bold(context),
                    textAlign: TextAlign.center,
                  ),
                  5.ph,
                  Text(
                    profile?.email ?? '',
                    style: AppStyle.fontSize16Regular(
                      context,
                    ).copyWith(color: AppColors.descContainerColor),
                    textAlign: TextAlign.center,
                  ),
                  5.ph,
                  Text(
                    profile?.phoneNumber ?? '',
                    style: AppStyle.fontSize16Regular(
                      context,
                    ).copyWith(color: AppColors.descContainerColor),
                    textAlign: TextAlign.center,
                  ),
                  20.ph,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.linked_units.tr(),
                      style: AppStyle.fontSize22Bold(
                        context,
                      ).copyWith(fontSize: 18.sp),
                    ),
                  ),
                  10.ph,
                  Expanded(
                    child: isLoading
                        ? ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return CustomContainerInformation(
                                width: 50.w,
                                height: 50.h,
                                titleContainer: 'Loading...',
                                descriptionContainer: '',
                              ).paddingOnly(bottom: 10.h);
                            },
                          )
                        : linkedUnits.isEmpty
                        ? Center(
                            child: Text(
                              LocaleKeys.no_new_unit_available.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: linkedUnits.length,
                            itemBuilder: (context, index) {
                              final unit = linkedUnits[index];
                              return CustomContainerInformation(
                                width: 50.w,
                                height: 50.h,
                                titleContainer: unit.name ?? '',
                                descriptionContainer: "",
                                imageUrl: unit.imageUrl?.url,
                              ).paddingOnly(bottom: 10.h);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
