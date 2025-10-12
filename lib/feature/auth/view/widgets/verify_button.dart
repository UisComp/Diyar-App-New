
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/auth/controller/auth_controller.dart';
import 'package:diyar_app/feature/auth/controller/auth_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({
    super.key,
    required this.formKey,
    required this.authController,
  });

  final GlobalKey<FormState> formKey;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthController, AuthState>(
      listener: (context, authState) {},
      builder: (context, authState) {
        return Center(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 80,
                maxWidth: double.infinity,
              ),
              child: CustomButton(
                isLoading: authState is VerifyOtpLoadingState,
                buttonText: LocaleKeys.verify.tr(),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await authController.verifyOtp();
                  }
                },
                buttonColor: AppColors.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
