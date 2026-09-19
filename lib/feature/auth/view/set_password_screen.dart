import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/auth/controller/set_password_controller.dart';
import 'package:diyar_app/feature/auth/controller/set_password_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_error_handler.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_navigation.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/feature/auth/view/widgets/custom_logo.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Last step of the first login and of "Forgot password?": choose a
/// password, then the resident is logged in.
class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  void _onState(BuildContext context, SetPasswordState state) {
    if (state is SetPasswordSuccessState) {
      goHomeAfterSignIn(
        context,
        message: LocaleKeys.password_set_successfully.tr(),
      );
    }
    if (state is SetPasswordFailureState) {
      if (state.tokenExpired) {
        AppFunctions.errorMessage(
          context,
          message: LocaleKeys.err_session_expired.tr(),
        );
        context.go(RoutesName.login);
        return;
      }
      showAuthError(context, state.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = SetPasswordController.get(context);
    final surface = AppSurface.of(context);
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.set_password_title.tr()),
      body: SafeArea(
        child: BlocConsumer<SetPasswordController, SetPasswordState>(
          listener: _onState,
          builder: (context, state) {
            final isLoading = state is SetPasswordLoadingState;
            return Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          24.ph,
                          const CustomLogo(),
                          24.ph,
                          AppText(
                            LocaleKeys.set_password_message.tr(),
                            textAlign: TextAlign.center,
                            style: AppStyle.fontSize14Regular(
                              context,
                            ).copyWith(color: surface.textSecondary),
                          ).paddingSymmetric(horizontal: 24.w),
                          24.ph,
                          AuthPasswordField(
                            controller: controller.passwordController,
                            hintText: LocaleKeys.new_password.tr(),
                          ),
                          15.ph,
                          AuthPasswordField(
                            controller: controller.confirmationController,
                            hintText: LocaleKeys.confirm_new_password.tr(),
                            validator: (value) =>
                                ValidatorHelper.validatePasswordConfirmation(
                                  value,
                                  originalPassword:
                                      controller.passwordController.text,
                                  emptyMessage: LocaleKeys
                                      .please_enter_your_password
                                      .tr(),
                                  notMatchMessage: LocaleKeys
                                      .passwords_do_not_match
                                      .tr(),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    buttonHeight: 52.h,
                    isLoading: isLoading,
                    buttonColor: AppColors.primaryColor,
                    buttonText: LocaleKeys.save_and_sign_in.tr(),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        controller.submit();
                      }
                    },
                  ).paddingAll(16.sp),
                  const DesignedByFooter(compact: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
