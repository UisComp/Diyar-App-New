import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/auth/view/widgets/dont_have_account_with_sign_up.dart';
import 'package:diyar_app/feature/auth/view/widgets/user_text_form_field_with_login_button.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
   final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Assets.images.diyarPmc
                          .image(
                            height: 250.h,
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          )
                          .paddingOnly(top: 20.h),
                          15.ph,
                      Text(
                        LocaleKeys.login_message.tr(),
                        style: AppStyle.fontSize16Regular,
                      ),
                      24.ph,
                      UserTextFormFieldWithLoginButton(formKey: formKey),
                    ],
                  ),
                ),
              ),
            ),
            const DontHaveAccountWithSignUp(),
          ],
        ),
      ),
    );
  }
}
