import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCode extends StatelessWidget {
  const CustomPinCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        final AuthController authController = AuthController.get(context);
        return PinCodeTextField(
          enablePinAutofill: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          appContext: context,
          controller: authController.otpController,
          length: 6,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8.r),
            fieldHeight: 45.h,
            fieldWidth: 45.w,
            activeFillColor: AppColors.whiteColor,
            inactiveFillColor: AppColors.whiteColor,
            selectedFillColor: Colors.grey.shade200,
            inactiveColor: Colors.grey.shade400,
            selectedColor: AppColors.primaryColor,
            activeColor: AppColors.primaryColor,
          ),
          cursorColor: AppColors.primaryColor,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          validator: (pinCode) {
            if (pinCode == null || pinCode.isEmpty) {
              return LocaleKeys.please_enter_otp.tr();
            } else if (pinCode.length < 6) {
              return LocaleKeys.otp_must_be_6_digits.tr();
            }
            return null;
          },
          onChanged: (value) {},
          onCompleted: (value) async {
            authController.verifyOtp();
          },
        );
      },
    );
  }
}
