import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/hive_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/dont_have_account_with_sign_up.dart';
import 'package:diyar_app/feature/auth/view/widgets/user_text_form_field_with_login_button.dart';
import 'package:diyar_app/feature/settings/controller/settings_controller.dart';
import 'package:diyar_app/feature/settings/controller/settings_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../notifications/controller/notification_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late AuthController authController;
  late SettingsController settingsController;
  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
    settingsController = SettingsController.get(context);
    settingsController.initialize();
    loadBio();
  }

  Future<void> loadBio() async {
    enableBiometric = await HiveHelper.getFromHive(
      key: AppConstants.enableBiometric,
    );
  }

  Future<void> _loginWithBiometrics() async {
    try {
      final isAuthenticated = await context
          .read<SettingsController>()
          .authenticateWithBiometrics();
      if (!isAuthenticated) {
        AppLogger.error('Biometric authentication failed');
        return;
      }
      final userName = await HiveHelper.getFromHive(key: AppConstants.myEmail);
      final password = await secureStorage.read(key: AppConstants.myPassword);
      if (userName == null || password == null) {
        AppLogger.warning('No saved credentials found');

        if (!mounted) return;
        AppFunctions.errorMessage(
          context,
          message: LocaleKeys.biometric_authentication_failed.tr(),
        );
        return;
      }
      authController.emailControllerForLogin.text = userName;
      authController.passwordControllerForLogin.text = password;
      AppLogger.success('Loaded credentials after biometric success');
      await authController.login();
    } catch (e) {
      AppLogger.error('Biometric login error: $e');
      if (!mounted) return;
      AppFunctions.errorMessage(
        context,
        message: LocaleKeys.biometric_authentication_failed.tr(),
      );
    }
  }

  Future<void> fetchNotifications() async {
    await NotificationController.get(
      context,
    ).fetchAllNotifications(refresh: true, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsController, SettingsState>(
      listener: (context, settingsState) {},
      builder: (context, settingsState) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: BlocConsumer<AuthController, AuthState>(
                    listener: (context, authState) {
                      if (authState is LoginSuccessState) {
                        fetchNotifications();

                        AppFunctions.successMessage(
                          context,
                          message: LocaleKeys.login_successfully.tr(),
                        );
                        context.go(RoutesName.homeLayout);
                      }
                      if (authState is LoginFailureState) {
                        AppFunctions.errorMessage(
                          description:
                              authController.loginResponseModel.message,
                          context,
                          message: LocaleKeys.login_failed.tr(),
                        );
                      }
                    },
                    builder: (context, authState) {
                      return SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Assets.images.diyarNew
                                  .image(
                                    height: 300.h,
                                    width: double.infinity,
                                    fit: BoxFit.scaleDown,
                                  )
                                  .paddingOnly(top: 20.h),
                              Text(
                                LocaleKeys.login_message.tr(),
                                style: AppStyle.fontSize16Regular(context),
                              ),
                              24.ph,
                              UserTextFormFieldWithLoginButton(
                                formKey: formKey,
                              ),
                              24.ph,
                              if (enableBiometric != null &&
                                  enableBiometric == true)
                                CustomButton(
                                  image: Assets.images.svg.biometric,
                                  animationDuration: Duration(
                                    milliseconds: 300,
                                  ),
                                  isLoading: settingsState is BiometricLoading,
                                  buttonColor: authState is LoginLoadingState
                                      ? AppColors.greyColor
                                      : AppColors.primaryColor,
                                  buttonText: LocaleKeys.loginWithBiometric
                                      .tr(),
                                  onPressed: authState is LoginLoadingState
                                      ? null
                                      : () async {
                                          await _loginWithBiometrics();
                                        },
                                ).paddingSymmetric(horizontal: 16.w),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const DontHaveAccountWithSignUp(),
              ],
            ),
          ),
        );
      },
    );
  }
}
