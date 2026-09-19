import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/auth/controller/otp_controller.dart';
import 'package:diyar_app/feature/auth/controller/otp_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_error_handler.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Texts a code to the number and checks it. Used by the first login,
/// "Forgot password?" and registration.
class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  final formKey = GlobalKey<FormState>();

  /// The first code goes out on open; confirm only the resends.
  bool _firstCodeSent = false;

  @override
  void initState() {
    super.initState();
    OtpController.get(context).sendCode();
  }

  void _onState(BuildContext context, OtpState state) {
    final controller = OtpController.get(context);
    final args = controller.args;
    switch (state) {
      case OtpVerifiedState(:final token):
        if (args.purpose == OtpPurpose.register) {
          context.pushReplacement(
            RoutesName.registerDetailsScreen,
            extra: RegisterDetailsArgs(
              phone: args.phone,
              registrationToken: token,
            ),
          );
        } else {
          context.pushReplacement(
            RoutesName.setPasswordScreen,
            extra: SetPasswordArgs(
              phone: args.phone,
              setupToken: token,
              isReset: args.purpose == OtpPurpose.resetPassword,
            ),
          );
        }
      case OtpSentState():
        if (_firstCodeSent) {
          AppFunctions.successMessage(
            context,
            message: LocaleKeys.code_sent.tr(),
          );
        }
        _firstCodeSent = true;
      case OtpSendFailureState(:final result):
        // Account problems (not registered, pending…) open a dialog whose
        // action leads to the right screen.
        showAuthError(context, result, phone: args.phone);
      case OtpVerifyFailureState(:final result):
        if (ApiErrorCodes.isDeadCode(result.errorCode) ||
            result.errorCode == ApiErrorCodes.invalid) {
          AppFunctions.errorMessage(context, message: apiErrorMessage(result));
        } else {
          showAuthError(context, result, phone: args.phone);
        }
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = OtpController.get(context);
    final surface = AppSurface.of(context);
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.verify_phone_title.tr()),
      body: SafeArea(
        child: BlocConsumer<OtpController, OtpState>(
          listener: _onState,
          builder: (context, state) {
            final verifying = state is OtpVerifyingState;
            final sending = state is OtpSendingState;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          32.ph,
                          Icon(
                            Icons.sms_outlined,
                            size: 56.sp,
                            color: AppColors.primaryColor,
                          ),
                          20.ph,
                          AppText(
                            LocaleKeys.enter_sms_code.tr(),
                            textAlign: TextAlign.center,
                            style: AppStyle.fontSize16Regular(
                              context,
                            ).copyWith(color: surface.textSecondary),
                          ),
                          6.ph,
                          Text(
                            displayPhone(controller.args.phone),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: AppStyle.fontSize18Bold(
                              context,
                            ).copyWith(color: AppColors.primaryColor),
                          ),
                          32.ph,
                          OtpCodeField(
                            controller: controller.codeController,
                            length: OtpController.codeLength,
                            enabled: !verifying,
                            onCompleted: (_) => controller.verify(),
                          ),
                          12.ph,
                          ResendCodeRow(
                            secondsLeft: controller.resendIn,
                            isSending: sending,
                            onResend: controller.canResend
                                ? controller.sendCode
                                : null,
                          ),
                          24.ph,
                          CustomButton(
                            buttonHeight: 52.h,
                            buttonText: LocaleKeys.verify.tr(),
                            isLoading: verifying,
                            buttonColor: AppColors.primaryColor,
                            onPressed: sending
                                ? null
                                : () {
                                    if (controller.codeController.text.length <
                                        OtpController.codeLength) {
                                      AppFunctions.errorMessage(
                                        context,
                                        message: LocaleKeys.otp_must_be_6_digits
                                            .tr(),
                                      );
                                      return;
                                    }
                                    controller.verify();
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const DesignedByFooter(compact: true),
              ],
            );
          },
        ),
      ),
    );
  }
}
