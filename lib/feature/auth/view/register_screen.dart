import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_phone_field.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/view/widgets/already_have_account_with_sign_in.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// Registration, step 1: the phone number, proved by an SMS code on the
/// next screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.initialPhone});

  /// e.g. the number that wasn't registered at login.
  final String? initialPhone;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  late final PhoneController phoneController = PhoneController(
    initialValue: _initialPhone(widget.initialPhone),
  );

  static PhoneNumber _initialPhone(String? phone) {
    if (phone != null && phone.isNotEmpty) {
      try {
        return PhoneNumber.parse(phone);
      } catch (_) {}
    }
    return const PhoneNumber(isoCode: IsoCode.EG, nsn: '');
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.push(
      RoutesName.phoneOtpScreen,
      extra: OtpArgs(
        phone: phoneController.value.international,
        purpose: OtpPurpose.register,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: AuthScrollColumn(
                  children: [
                    AuthHeader(
                      title: LocaleKeys.create_account.tr(),
                      subtitle: LocaleKeys.register_phone_message.tr(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthFieldLabel(
                          title: LocaleKeys.register_phone_title.tr(),
                          hint: LocaleKeys.register_phone_hint.tr(),
                        ),
                        CustomPhoneField(
                          controller: phoneController,
                          hintText: LocaleKeys.login_phone_placeholder.tr(),
                        ),
                        18.ph,
                        CustomButton(
                          buttonHeight: 52.h,
                          buttonText: LocaleKeys.verify_number.tr(),
                          buttonColor: AppColors.primaryColor,
                          onPressed: _continue,
                        ).paddingSymmetric(horizontal: 16.w),
                        14.ph,
                        AppText(
                          LocaleKeys.by_continue.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: surface.textSecondary,
                            height: 1.4,
                          ),
                        ).paddingSymmetric(horizontal: 32.w),
                      ],
                    ),
                    6.ph,
                  ],
                ),
              ),
            ),
            const AlreadyHaveAccountWithSignIn(),
            const DesignedByFooter(compact: true),
          ],
        ),
      ),
    );
  }
}
