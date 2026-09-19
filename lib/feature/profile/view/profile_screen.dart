import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/finance/view/finance_screen.dart'
    show canAccessFinance;
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/feature/profile/view/widgets/image_profile.dart';
import 'package:diyar_app/feature/profile/view/widgets/list_view_linked_units.dart';
import 'package:diyar_app/feature/profile/view/widgets/profile_documents_tile.dart';
import 'package:diyar_app/feature/profile/view/widgets/profile_logout_tile.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:diyar_app/feature/auth/model/user_phone.dart';
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

  bool get _isGuest => userModel?.data?.accessToken == null;

  @override
  void initState() {
    super.initState();
    _profileController = ProfileController.get(context);
    if (!_isGuest) _profileController.initProfileInfoControllers();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_isGuest) return;
    await Future.wait([
      _profileController.getMyProfile(),
      _profileController.getUserLinkedUnits(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageController, LanguageState>(
      buildWhen: (previous, current) => current is ChangeCurrentLanguageState,
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(titleAppBar: LocaleKeys.profile.tr()),
          body: BlocBuilder<ProfileController, ProfileState>(
            buildWhen: (previous, current) =>
                current is GetMyProfileLoadingState ||
                current is GetMyProfileSuccessState ||
                current is GetMyProfileFailureState ||
                current is GetUserLinkedUnitsLoadingState ||
                current is GetUserLinkedUnitsSuccessfullyState ||
                current is GetUserLinkedUnitsFailureState,
            builder: (context, state) {
              final controller = _profileController;
              final profile = controller.profileResponseModel.data;
              // Only skeleton the header on first load; a refresh keeps the
              // current details on screen.
              final isHeaderLoading =
                  !_isGuest &&
                  profile == null &&
                  state is! GetMyProfileFailureState;

              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _loadProfile,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                  children: [
                    Skeletonizer(
                      enabled: isHeaderLoading,
                      child: ImageProfile(
                        profile: isHeaderLoading
                            ? _placeholderProfile
                            : profile,
                        isGuest: _isGuest,
                      ),
                    ),
                    if (!_isGuest) ...[
                      // Documents used to live in the finance tab, so they
                      // keep the same audience.
                      if (canAccessFinance) ...[
                        16.ph,
                        const ProfileDocumentsTile(),
                      ],
                      16.ph,
                      ListViewLinkedUnits(
                        linkedUnits:
                            controller.userLinkedUnitsResponseModel.data ?? [],
                        isLoading: controller.isUnitsLoading,
                        hasError: controller.unitsFailed,
                        onRetry: controller.getUserLinkedUnits,
                      ),
                      24.ph,
                      const ProfileLogoutTile(),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Sample content sized like real data so the header skeleton matches the
  /// loaded layout.
  static final _placeholderProfile = ProfileData(
    name: 'Resident Test User',
    email: 'resident@example.com',
    phones: const [UserPhone(id: 0, phone: '+201000000000', isPrimary: true)],
  );
}
