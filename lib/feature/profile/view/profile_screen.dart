import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/view/widgets/empty_linked_units.dart';
import 'package:diyar_app/feature/profile/view/widgets/image_profile.dart';
import 'package:diyar_app/feature/profile/view/widgets/list_view_linked_units.dart';
import 'package:diyar_app/feature/profile/view/widgets/user_info.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = ProfileController.get(context);
    _initProfileData();
  }

  Future<void> _initProfileData() async {
    await _profileController.getMyProfile();
    await _profileController.getUserLinkedUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.profile.tr()),
      body: BlocBuilder<ProfileController, ProfileState>(
        buildWhen: (previous, current) =>
            current is GetMyProfileSuccessState ||
            current is EditingProfileSuccessfullyState ||
            current is PickingImageProfileSuccessfully ||
            current is GetUserLinkedUnitsSuccessfullyState ||
            current is GetMyProfileLoadingState ||
            current is GetUserLinkedUnitsLoadingState,
        builder: (context, state) {
          final controller = _profileController;
          final isLoading =
              state is GetMyProfileLoadingState ||
              state is GetUserLinkedUnitsLoadingState;
          final profile = controller.profileResponseModel.data;
          final linkedUnits =
              controller.userLinkedUnitsResponseModel.data ?? [];
          return Skeletonizer(
            enabled: isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.ph,
                  ImageProfile(profile: profile),
                  10.ph,
                  UserInfo(profile: profile),
                  10.ph,
                  Expanded(
                    child: linkedUnits.isEmpty
                        ? const EmptyLinkedUnits()
                        : ListViewLinkedUnits(linkedUnits: linkedUnits),
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
