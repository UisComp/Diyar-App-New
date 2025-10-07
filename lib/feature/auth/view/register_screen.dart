import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/already_have_account_with_sign_in.dart';
import 'package:diyar_app/feature/auth/view/widgets/user_text_form_field_with_register_button.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
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
                      20.ph,
                      Assets.images.diyarPmc
                          .image(
                            height: 270.h,
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          )
                          .paddingOnly(top: 20.h),
                      30.ph,
                      Text(
                        LocaleKeys.create_account.tr(),
                        style: AppStyle.fontSize22Bold(context)
                      ),
                      24.ph,
                      const UserTextFormFieldForRegister(),
                      24.ph,
                      BlocBuilder<AuthController, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is RegisterLoadingState;
                          final authController = AuthController.get(context);
                          return CustomButton(
                            buttonHeight: 50.h,
                            buttonText: LocaleKeys.sign_up.tr(),
                            isLoading: isLoading,
                            onPressed: () async {
                              if (!isLoading &&
                                  formKey.currentState!.validate()) {
                                await authController.register();
                              }
                            },
                            buttonColor: AppColors.primaryColor,
                          );
                        },
                      ).paddingSymmetric(horizontal: 16.sp),
                      16.ph,
                      const AlreadyHaveAccountWithSignIn(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
