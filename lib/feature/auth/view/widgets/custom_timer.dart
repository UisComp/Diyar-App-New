import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({super.key});

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = AuthController.get(context);
    authController.initTimer();
  }

  @override
  void dispose() {
    authController.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              authController.remainingSeconds > 0
                  ? "${LocaleKeys.resend_code_in.tr()} ${authController.minutes}:${authController.seconds}"
                  : LocaleKeys.did_not_get_the_code.tr(),
              style: TextStyle(color: AppColors.greyColor, fontSize: 14.sp),
            ),
            5.pw,
            if (authController.remainingSeconds == 0)
              InkWell(
                onTap: () async {
                  await authController.forgetPassword();
                  await authController.startTimer();
                },
                child: Text(
                  LocaleKeys.resend_otp.tr(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
