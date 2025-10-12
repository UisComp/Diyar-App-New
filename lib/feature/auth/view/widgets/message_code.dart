import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageCode extends StatelessWidget {
  const MessageCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor),
            children: [
              TextSpan(
                text: "${LocaleKeys.enter_the_code_sent_to_your_email.tr()} ",
              ),
              if (savedEmailForForgetPasword != null &&
                  savedEmailForForgetPasword!.isNotEmpty)
                TextSpan(
                  text: savedEmailForForgetPasword,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
