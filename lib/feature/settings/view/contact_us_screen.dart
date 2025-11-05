import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.contact_us.tr()),
      body: BlocConsumer<SettingsController, SettingsState>(
        listener: (context, settingsState) {
          if (settingsState is SendEmailSuccessfullyState) {
            context.read<SettingsController>().clearFields();
            AppFunctions.successMessage(
              context,
              message: LocaleKeys.sent_email_successfully.tr(),
            );
          }
          if (settingsState is SendEmailFailureState) {
            AppFunctions.errorMessage(
              context,
              message: settingsState.error ?? LocaleKeys.sent_email_failed.tr(),
            );
          }
        },
        builder: (context, settingsState) {
          final settingsController = SettingsController.get(context);
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.ph,
                  Text(
                    LocaleKeys.we_are_here_to_help.tr(),
                    style: AppStyle.fontSize22Bold(context),
                  ).paddingSymmetric(horizontal: 16.w),
                  12.ph,
                  Text(
                    LocaleKeys.desc_we_are_here_to_help.tr(),
                    style: AppStyle.fontSize16Regular(context),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 16.w),
                  28.ph,
                  Text(
                    LocaleKeys.contact_form.tr(),
                    style: AppStyle.fontSize22Bold(context),
                  ).paddingSymmetric(horizontal: 16.w),
                  20.ph,
                  CustomTextFormField(
                    validator: (name) {
                      if (name!.isEmpty) {
                        return LocaleKeys.please_enter_your_name.tr();
                      }
                      return null;
                    },
                    controller: settingsController.nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hintText: LocaleKeys.your_name.tr(),
                    keyboardType: TextInputType.name,
                  ),
                  24.ph,
                  CustomTextFormField(
                    validator: (email) => ValidatorHelper.validateEmail(
                      email,
                      emptyMessage: LocaleKeys.please_enter_your_email.tr(),
                      invalidMessage: LocaleKeys.please_enter_a_valid_email
                          .tr(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: settingsController.emailController,
                    hintText: LocaleKeys.your_email.tr(),
                    keyboardType: TextInputType.name,
                  ),
                  24.ph,
                  CustomTextFormField(
                    validator: (message) {
                      if (message!.isEmpty) {
                        return LocaleKeys.please_enter_your_message.tr();
                      }
                      return null;
                    },
                    hintText: LocaleKeys.message_contact_us.tr(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: settingsController.messageController,
                    maxLines: 10,
                    isDense: true,
                  ),
                  24.ph,
                  CustomButton(
                    buttonColor: AppColors.primaryColor,
                    buttonText: LocaleKeys.submit.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await settingsController.sendEmail();
                      }
                    },
                  ).paddingSymmetric(horizontal: 16.w),
                  28.ph,
                  Text(
                    LocaleKeys.other_contact_methods.tr(),
                    style: AppStyle.fontSize22Bold(context),
                  ).paddingSymmetric(horizontal: 16.w),
                  CustomContainerInformation(
                    titleContainer: LocaleKeys.email.tr(),
                    descriptionContainer:
                        settingsController
                            .configResponseModel
                            .data
                            ?.contactEmail ??
                        "",
                    svgIcon: Assets.images.svg.contactUs,
                  ),
                  24.ph,
                  CustomContainerInformation(
                    titleContainer: LocaleKeys.phone.tr(),
                    descriptionContainer:
                        settingsController
                            .configResponseModel
                            .data
                            ?.contactPhone ??
                        "",
                    svgIcon: Assets.images.svg.phoneCall,
                  ),
                  40.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
