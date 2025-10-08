import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/custom_pin_code.dart';
import 'package:diyar_app/feature/auth/view/widgets/custom_timer.dart';
import 'package:diyar_app/feature/auth/view/widgets/message_code.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late AuthController authController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.otp_verification.tr()),
      body: Padding(
        padding: EdgeInsets.all(32.0.sp),
        child: Form(
          key: formKey,
          child: BlocConsumer<AuthController, AuthState>(
            listener: (context, authState) {
              if (authState is VerifyOtpSuccessState) {
                AppFunctions.successMessage(
                  context,
                  message:
                      authController.otpVerifyResponseModel.message ??
                      LocaleKeys.otp_verify_successfully.tr(),
                );
                context.push(RoutesName.resetPasswordScreen);
              }
              if (authState is VerifyOtpFailureState) {
                AppFunctions.errorMessage(
                  context,
                  message:
                      authController.otpVerifyResponseModel.message ??
                      LocaleKeys.otp_verify_failed.tr(),
                );
              }
            },
            builder: (context, authState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const MessageCode(),
                  40.ph,
                  const CustomPinCode(),
                  10.ph,
                  const CustomTimer(),
                  20.ph,
                  CustomButton(
                    isLoading: authState is VerifyOtpLoadingState,
                    buttonText: LocaleKeys.verify.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await authController.verifyOtp();
                      }
                    },
                    buttonColor: AppColors.primaryColor,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
