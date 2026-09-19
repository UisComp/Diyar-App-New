import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_phone_field.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_request_controller.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_request_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Add a number, or replace one: new number → code → request. Returns true
/// when the request was sent.
class PhoneRequestSheet extends StatefulWidget {
  const PhoneRequestSheet({super.key, this.replacedPhone});

  /// The number being replaced, or null to add one.
  final String? replacedPhone;

  static Future<bool?> show(
    BuildContext context, {
    int? replacedPhoneId,
    String? replacedPhone,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppSurface.of(context).card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => PhoneRequestController(replacedPhoneId: replacedPhoneId),
        child: PhoneRequestSheet(replacedPhone: replacedPhone),
      ),
    );
  }

  @override
  State<PhoneRequestSheet> createState() => _PhoneRequestSheetState();
}

class _PhoneRequestSheetState extends State<PhoneRequestSheet> {
  final formKey = GlobalKey<FormState>();

  void _onState(BuildContext context, PhoneRequestState state) {
    if (state is PhoneRequestSubmittedState) {
      Navigator.of(context).pop(true);
    }
    if (state is PhoneRequestFailureState) {
      AppFunctions.errorMessage(
        context,
        message: apiErrorMessage(state.result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = PhoneRequestController.get(context);
    final surface = AppSurface.of(context);
    final isReplace = widget.replacedPhone != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: BlocConsumer<PhoneRequestController, PhoneRequestState>(
        listener: _onState,
        builder: (context, state) {
          final codeSentTo = controller.codeSentTo;
          final sending = state is PhoneRequestSendingCodeState;
          final submitting = state is PhoneRequestSubmittingState;
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: surface.border,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  16.ph,
                  _padded(
                    AppText(
                      isReplace
                          ? LocaleKeys.replace_number.tr()
                          : LocaleKeys.add_number.tr(),
                      style: AppStyle.fontSize18Bold(context),
                    ),
                  ),
                  if (isReplace) ...[
                    4.ph,
                    _padded(
                      AppText(
                        LocaleKeys.replacing_number.tr(
                          args: [displayPhone(widget.replacedPhone!)],
                        ),
                        style: AppStyle.fontSize14Regular(
                          context,
                        ).copyWith(color: surface.textSecondary),
                      ),
                    ),
                  ],
                  16.ph,
                  if (codeSentTo == null) ...[
                    CustomPhoneField(
                      controller: controller.phoneController,
                      hintText: LocaleKeys.new_number.tr(),
                    ),
                    20.ph,
                    _padded(
                      CustomButton(
                        buttonHeight: 50.h,
                        buttonText: LocaleKeys.send_code.tr(),
                        isLoading: sending,
                        buttonColor: AppColors.primaryColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            controller.sendCode();
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    _padded(
                      PhoneNumberChip(
                        phone: codeSentTo,
                        onChange: submitting ? null : controller.changeNumber,
                      ),
                    ),
                    16.ph,
                    _padded(
                      AppText(
                        LocaleKeys.enter_code_sent_to_new_number.tr(),
                        style: AppStyle.fontSize14Regular(
                          context,
                        ).copyWith(color: surface.textSecondary),
                      ),
                    ),
                    12.ph,
                    _padded(
                      OtpCodeField(
                        controller: controller.codeController,
                        length: PhoneRequestController.codeLength,
                        enabled: !submitting,
                        onCompleted: (_) => controller.submit(),
                      ),
                    ),
                    ResendCodeRow(
                      secondsLeft: controller.resendIn,
                      isSending: sending,
                      onResend: controller.resendIn == 0
                          ? controller.sendCode
                          : null,
                    ),
                    12.ph,
                    _padded(
                      CustomButton(
                        buttonHeight: 50.h,
                        buttonText: LocaleKeys.send_request.tr(),
                        isLoading: submitting,
                        buttonColor: AppColors.primaryColor,
                        onPressed: sending ? null : controller.submit,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _padded(Widget child) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: child,
  );
}
