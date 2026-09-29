import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_phone_field.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/auth/controller/login_controller.dart';
import 'package:diyar_app/feature/auth/controller/login_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_error_handler.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_navigation.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/feature/auth/view/widgets/dont_have_account_with_sign_up.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// The one login for everyone: residents with their phone number, security
/// staff with their work email, both with a password.
///
/// A WhatsApp code is only sent when asked for: "Sign in with WhatsApp code"
/// (accounts created by staff, first login) and "Forgot password?".
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SettingsController.get(context).initialize();
    loadBio();
  }

  Future<void> loadBio() async {
    final enabled = await HiveHelper.getFromHive(
      key: AppConstants.enableBiometric,
    );
    if (!mounted) return;
    setState(() => enableBiometric = enabled);
  }

  LoginController get _controller => LoginController.get(context);

  void _signIn() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _controller.login();
  }

  /// First login of an account created by staff: send a WhatsApp code, then
  /// the resident sets a password.
  void _signInWithCode() {
    final controller = _controller;
    final id = controller.identifier;
    if (id == null || !id.isPhone) {
      // Codes go to phone numbers: bring the phone field back.
      controller.setUseEmail(false);
      AppFunctions.warningMessage(
        context,
        message: LocaleKeys.enter_phone_for_code.tr(),
      );
      return;
    }
    _openCode(id.value, OtpPurpose.login);
  }

  /// A phone number resets by WhatsApp code; an email (security staff)
  /// by email.
  void _forgotPassword() {
    final id = _controller.identifier;
    if (id == null) {
      AppFunctions.warningMessage(
        context,
        message: _controller.usesEmail
            ? LocaleKeys.please_enter_a_valid_email.tr()
            : LocaleKeys.enter_phone_for_code.tr(),
      );
      return;
    }
    if (id.isEmail) {
      context.push(RoutesName.forgetPasswordScreen, extra: id.value);
    } else {
      _openCode(id.value, OtpPurpose.resetPassword);
    }
  }

  void _openCode(String phone, OtpPurpose purpose) => context.push(
    RoutesName.phoneOtpScreen,
    extra: OtpArgs(phone: phone, purpose: purpose),
  );

  Future<void> _loginWithBiometrics() async {
    final controller = _controller;
    try {
      final isAuthenticated = await SettingsController.get(
        context,
      ).authenticateWithBiometrics();
      if (!isAuthenticated) {
        AppLogger.error('Biometric authentication failed');
        return;
      }
      await controller.loginWithSavedCredentials();
    } catch (e) {
      AppLogger.error('Biometric login error: $e');
      if (!mounted) return;
      AppFunctions.errorMessage(
        context,
        message: LocaleKeys.biometric_authentication_failed.tr(),
      );
    }
  }

  void _onState(BuildContext context, LoginState state) {
    switch (state) {
      case SignInSuccessState():
        goHomeAfterSignIn(context);
      case SignInFailureState(
        :final result,
        :final phone,
        :final savedLoginOutdated,
      ):
        if (savedLoginOutdated) {
          setState(() => enableBiometric = false);
          AppFunctions.warningMessage(
            context,
            message: LocaleKeys.saved_login_outdated.tr(),
            description: apiErrorMessage(result),
          );
        } else if (result.errorCode == ApiErrorCodes.passwordNotSet &&
            phone != null) {
          // An account created by staff: its first login needs a code.
          showAuthActionDialog(
            context,
            title: LocaleKeys.set_password_title.tr(),
            message: apiErrorMessage(result),
            actionText: LocaleKeys.send_code.tr(),
            onAction: () => _openCode(phone, OtpPurpose.login),
          );
        } else if (result.errorCode == ApiErrorCodes.wrongCredentials) {
          AppFunctions.errorMessage(
            context,
            message: phone != null
                ? LocaleKeys.err_wrong_credentials_phone.tr()
                : LocaleKeys.err_wrong_credentials_email.tr(),
          );
        } else {
          showAuthError(context, result, phone: phone);
        }
      case NoSavedLoginState():
        AppFunctions.errorMessage(
          context,
          message: LocaleKeys.biometric_authentication_failed.tr(),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final surface = AppSurface.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginController, LoginState>(
          listener: _onState,
          builder: (context, state) {
            final loading = state is SignInLoadingState;
            return Form(
              key: formKey,
              child: AuthScrollColumn(
                children: [
                  AuthHeader(
                    title: LocaleKeys.login_title.tr(),
                    subtitle: LocaleKeys.login_subtitle.tr(),
                    trailing: AuthHeaderChip(
                      label: LocaleKeys.guest_mode.tr(),
                      onTap: () => context.go(RoutesName.homeLayout),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Residents sign in with a phone number, security
                        // staff with their work email.
                        AuthSegmentedControl(
                          labels: [
                            LocaleKeys.login_as_resident.tr(),
                            LocaleKeys.login_as_staff.tr(),
                          ],
                          icons: const [
                            Icons.phone_iphone_rounded,
                            Icons.badge_outlined,
                          ],
                          selected: controller.usesEmail ? 1 : 0,
                          onChanged: loading
                              ? (_) {}
                              : (index) => controller.setUseEmail(index == 1),
                        ).paddingSymmetric(horizontal: 16.w),
                        16.ph,
                        if (controller.usesEmail)
                          CustomTextFormField(
                            controller: controller.emailController,
                            hintText: LocaleKeys.login_email_title.tr(),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) => ValidatorHelper.validateEmail(
                              email?.trim(),
                              emptyMessage: LocaleKeys.please_enter_your_email
                                  .tr(),
                              invalidMessage: LocaleKeys
                                  .please_enter_a_valid_email
                                  .tr(),
                            ),
                            prefixIcon: const Icon(Icons.mail_outline_rounded),
                          )
                        else
                          CustomPhoneField(
                            controller: controller.phoneController,
                            hintText: LocaleKeys.login_phone_placeholder.tr(),
                            textInputAction: TextInputAction.next,
                          ),
                        12.ph,
                        AuthPasswordField(
                          controller: controller.passwordController,
                          hintText: LocaleKeys.password.tr(),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: loading ? null : _forgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: AppText(
                              LocaleKeys.forget_password.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 8.w),
                        4.ph,
                        // Biometrics sits beside the main action instead of
                        // taking a full-width row of its own.
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                buttonHeight: 52.h,
                                buttonText: LocaleKeys.sign_in.tr(),
                                isLoading: loading,
                                buttonColor: AppColors.primaryColor,
                                onPressed: _signIn,
                              ),
                            ),
                            if (enableBiometric == true) ...[
                              10.pw,
                              _BiometricButton(
                                busy: loading,
                                onPressed: _loginWithBiometrics,
                              ),
                            ],
                          ],
                        ).paddingSymmetric(horizontal: 16.w),
                        16.ph,
                        const AuthOrDivider(),
                        16.ph,
                        AuthOutlinedButton(
                          text: LocaleKeys.sign_in_with_code.tr(),
                          icon: Icons.chat_outlined,
                          onPressed: loading ? null : _signInWithCode,
                        ).paddingSymmetric(horizontal: 16.w),
                        8.ph,
                        AppText(
                          LocaleKeys.sign_in_with_code_hint.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: surface.textSecondary,
                            height: 1.4,
                          ),
                        ).paddingSymmetric(horizontal: 28.w),
                      ],
                    ),
                  ),
                  // Inside the scroll: pinned to the bottom on tall phones,
                  // scrolls on short ones instead of piling onto the form.
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Column(
                      children: [
                        const DontHaveAccountWithSignUp(),
                        DesignedByFooter(
                          compact: true,
                          showLogo: true,
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 16.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A square fingerprint button beside "Sign in".
class _BiometricButton extends StatelessWidget {
  const _BiometricButton({required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsController, SettingsState>(
      builder: (context, settingsState) {
        final working = busy || settingsState is BiometricLoading;
        return Tooltip(
          message: LocaleKeys.loginWithBiometric.tr(),
          child: SizedBox.square(
            dimension: 52.h,
            child: OutlinedButton(
              onPressed: working ? null : onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: working
                  ? SizedBox.square(
                      dimension: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    )
                  : Icon(
                      Icons.fingerprint_rounded,
                      size: 28.sp,
                      semanticLabel: LocaleKeys.loginWithBiometric.tr(),
                    ),
            ),
          ),
        );
      },
    );
  }
}
