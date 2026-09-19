import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/brand_logo_header.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Brand header with a title and a short explanation, at the top of the
/// login and registration screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Column(
      children: [
        BrandLogoHeader(height: 168.h, logoHeight: 104.h, borderRadius: 26),
        16.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: AppText(
            title,
            textAlign: TextAlign.center,
            style: AppStyle.fontSize22Bold(context).copyWith(
              fontSize: 21.sp,
              fontWeight: FontWeight.w800,
              color: surface.textPrimary,
            ),
          ),
        ),
        4.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: AppText(
            subtitle,
            textAlign: TextAlign.center,
            style: AppStyle.fontSize16Regular(context).copyWith(
              fontSize: 13.5.sp,
              color: surface.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// A password field with a show/hide toggle. Passwords are at least 8
/// characters.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;

  /// Defaults to "required, no spaces, at least 8 characters".
  final String? Function(String?)? validator;

  static String? validatePassword(String? password) =>
      ValidatorHelper.validatePhoneOrPassword(
        password,
        emptyMessage: LocaleKeys.please_enter_your_password.tr(),
        spaceMessage: LocaleKeys.please_enter_valid_password.tr(),
        minLength: 8,
        minLengthMessage: LocaleKeys.password_must_be_at_least_8_characters
            .tr(),
      );

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ?? AuthPasswordField.validatePassword,
      hintText: widget.hintText,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        ),
      ),
    );
  }
}

/// The 6-digit SMS code. Marked `oneTimeCode`, so iOS offers the code from
/// the keyboard.
class OtpCodeField extends StatelessWidget {
  const OtpCodeField({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.enabled = true,
    this.length = 6,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final bool enabled;
  final int length;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        controller: controller,
        // The controller belongs to the screen's controller.
        autoDisposeControllers: false,
        length: length,
        enabled: enabled,
        autoFocus: true,
        enablePinAutofill: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        animationType: AnimationType.fade,
        animationDuration: const Duration(milliseconds: 200),
        enableActiveFill: true,
        cursorColor: AppColors.primaryColor,
        textStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: surface.textPrimary,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10.r),
          fieldHeight: 50.h,
          fieldWidth: 44.w,
          activeFillColor: surface.card,
          inactiveFillColor: surface.card,
          selectedFillColor: surface.subtle,
          disabledColor: surface.border,
          inactiveColor: surface.border,
          selectedColor: AppColors.primaryColor,
          activeColor: AppColors.primaryColor,
        ),
        onChanged: (_) {},
        onCompleted: onCompleted,
      ),
    );
  }
}

/// "Resend code in 00:42", then a "Resend code" link.
class ResendCodeRow extends StatelessWidget {
  const ResendCodeRow({
    super.key,
    required this.secondsLeft,
    required this.onResend,
    this.isSending = false,
  });

  final int secondsLeft;
  final VoidCallback? onResend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    if (isSending) {
      return Center(
        child: AppText(
          LocaleKeys.sending_code.tr(),
          style: TextStyle(color: surface.textSecondary, fontSize: 14.sp),
        ),
      );
    }
    if (secondsLeft > 0) {
      final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
      final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
      return Center(
        child: AppText(
          '${LocaleKeys.resend_code_in.tr()} $minutes:$seconds',
          style: TextStyle(color: surface.textSecondary, fontSize: 14.sp),
        ),
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(
          LocaleKeys.did_not_get_the_code.tr(),
          style: TextStyle(color: surface.textSecondary, fontSize: 14.sp),
        ),
        TextButton(
          onPressed: onResend,
          child: AppText(
            LocaleKeys.resend_code.tr(),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// The phone number being used, always left-to-right, with an optional
/// "Change" link.
class PhoneNumberChip extends StatelessWidget {
  const PhoneNumberChip({
    super.key,
    required this.phone,
    this.onChange,
    this.verified = false,
  });

  final String phone;
  final VoidCallback? onChange;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: surface.cardDecoration(radius: 14.r),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.phone_iphone_rounded,
            color: verified ? AppColors.greenColor : AppColors.primaryColor,
            size: 20.sp,
          ),
          10.pw,
          Expanded(
            child: Text(
              displayPhone(phone),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: surface.textPrimary,
              ),
            ),
          ),
          if (onChange != null)
            TextButton(
              onPressed: onChange,
              child: AppText(
                LocaleKeys.change_number.tr(),
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A message with one action, e.g. "Number not registered — Sign up".
Future<void> showAuthActionDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? actionText,
  VoidCallback? onAction,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title, style: AppStyle.fontSize18Bold(dialogContext)),
      content: Text(message, style: AppStyle.fontSize14Regular(dialogContext)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            actionText == null ? LocaleKeys.ok.tr() : LocaleKeys.cancel.tr(),
          ),
        ),
        if (actionText != null)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onAction?.call();
            },
            child: Text(actionText),
          ),
      ],
    ),
  );
}

/// What a field is for, above it: the field itself only shows an example.
class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({super.key, required this.title, this.hint});

  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: AppStyle.fontSize14Bold(
              context,
            ).copyWith(color: surface.textPrimary),
          ),
          if (hint != null) ...[
            2.ph,
            AppText(
              hint!,
              style: AppStyle.fontSize12Regular(
                context,
              ).copyWith(color: surface.textSecondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}

/// "──── or ────" between the main action and the alternatives.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final line = Expanded(child: Divider(color: surface.border, height: 1));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AppText(
              LocaleKeys.or.tr(),
              style: TextStyle(fontSize: 12.sp, color: surface.textSecondary),
            ),
          ),
          line,
        ],
      ),
    );
  }
}

/// A secondary action next to the gradient [CustomButton]: outlined in the
/// brand color.
class AuthOutlinedButton extends StatelessWidget {
  const AuthOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20.sp), 8.pw],
                  Flexible(
                    child: AppText(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// "Don't have an account? Sign up": the question in grey, the action in
/// the brand color. Wraps instead of overflowing with large text.
class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, top: 2.h, left: 16.w, right: 16.w),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppText(
            prompt,
            style: TextStyle(fontSize: 14.sp, color: surface.textSecondary),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: AppText(
              action,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two choices in one pill, e.g. "Resident" / "Security staff". The chosen
/// one slides into place.
class AuthSegmentedControl extends StatelessWidget {
  const AuthSegmentedControl({
    super.key,
    required this.labels,
    required this.icons,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Container(
      height: 42.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: surface.subtle,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: surface.border),
      ),
      child: Row(
        children: [
          for (final (index, label) in labels.indexed)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: index == selected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 16.sp,
                        color: index == selected
                            ? AppColors.whiteColor
                            : surface.textSecondary,
                      ),
                      6.pw,
                      Flexible(
                        child: AppText(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: index == selected
                                ? AppColors.whiteColor
                                : surface.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Scrolls when the content is taller than the screen; otherwise spreads
/// the leftover space between its groups, so a short form doesn't leave one
/// big empty block.
class AuthScrollColumn extends StatelessWidget {
  const AuthScrollColumn({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.spaceBetween,
  });

  /// One entry per group; the space between them is shared.
  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: alignment,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
