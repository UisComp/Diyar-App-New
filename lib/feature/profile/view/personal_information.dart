import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_phone_field.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/view/widgets/profile_image.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  late ProfileController profileController;
  @override
  void initState() {
    super.initState();
    profileController = ProfileController.get(context);
    profileController.initProfileInfoControllers();
    profileController.getMyProfile();
  }

  @override
  void dispose() {
    super.dispose();
    profileController.disposeProfileInfoControllers();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileController, ProfileState>(
      listener: (context, profileState) {
        if (profileState is EditingProfileSuccessfullyState) {
          onEditProfileSuccess(context);
        }
        if (profileState is EditingProfileFailureState) {
          AppFunctions.errorMessage(
            context,
            message:
                profileState.error ?? LocaleKeys.update_profile_failure.tr(),
          );
        }
      },
      builder: (context, profileState) {
        final isLoading = profileState is GetMyProfileLoadingState;

        return PopScope(
          canPop:
              !(profileState is PickingImageProfileLoadingState ||
                  profileState is EditingProfileLoadingState),
          child: Scaffold(
            appBar: CustomAppBar(
              titleAppBar: LocaleKeys.personal_information.tr(),
            ),
            body: Skeletonizer(
              enabled: isLoading,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            32.ph,
                            const ProfileImage(),
                            Text(
                              LocaleKeys.name.tr(),
                            ).paddingSymmetric(horizontal: 16.w),
                            8.ph,
                            CustomTextFormField(
                              controller:
                                  profileController.nameProfileController,
                            ),
                            24.ph,
                            Text(
                              LocaleKeys.email.tr(),
                              style:
                                  AppStyle.fontSize14RegularNewsReader(
                                    context,
                                  ).copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ).paddingSymmetric(horizontal: 16.w),
                            8.ph,
                            CustomTextFormField(
                              validator: (emailProfile) =>
                                  ValidatorHelper.validateEmail(
                                    emailProfile,
                                    emptyMessage: LocaleKeys
                                        .please_enter_your_email
                                        .tr(),
                                    invalidMessage: LocaleKeys
                                        .please_enter_a_valid_email
                                        .tr(),
                                  ),
                              controller:
                                  profileController.emailProfileController,
                            ),
                            24.ph,
                            Text(
                              LocaleKeys.contact_mobile_number.tr(),
                            ).paddingSymmetric(horizontal: 16.w),
                            8.ph,
                            CustomPhoneField(
                              isEdit: true,
                              enabled: false,
                              controller:
                                  profileController.phoneProfileController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      isLoading: profileState is EditingProfileLoadingState,
                      buttonColor:
                          profileState is PickingImageProfileLoadingState
                          ? Colors.grey
                          : AppColors.primaryColor,
                      buttonText: LocaleKeys.save_changes.tr(),
                      onPressed: profileState is PickingImageProfileLoadingState
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                await profileController.editProfile();
                              }
                            },
                    ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onEditProfileSuccess(BuildContext context) async {
    AppFunctions.successMessage(
      context,
      message: LocaleKeys.update_profile_successfully.tr(),
    );
    await profileController.getMyProfile();

    context.pop();
  }
}
