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
    profileController.getMyProfile();
  }

  @override
  void dispose() {
    super.dispose();
    profileController.emailProfileController.dispose();
    profileController.nameProfileController.dispose();
    profileController.close();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.personal_information.tr()),
      body: BlocConsumer<ProfileController, ProfileState>(
        listener: (context, profileState) {
          if (profileState is EditingProfileSuccessfullyState) {
            AppFunctions.successMessage(
              context,
              message:
                  profileController.editProfileResponseModel.message ??
                  LocaleKeys.update_profile_successfully.tr(),
            );
            context.pop();
          }
          if (profileState is EditingProfileFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  profileController.editProfileResponseModel.message ??
                  LocaleKeys.update_profile_failure.tr(),
            );
          }
        },
        builder: (context, profileState) {
          final isLoading = profileState is GetMyProfileLoadingState;

          return Skeletonizer(
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
                            controller: profileController.nameProfileController,
                          ),
                          24.ph,
                          Text(
                            LocaleKeys.email.tr(),
                            style: AppStyle.fontSize14RegularNewsReader
                              (context)  .copyWith(
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
                    buttonColor: AppColors.primaryColor,
                    buttonText: LocaleKeys.save_changes.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await profileController.editProfile();
                      }
                    },
                  ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
