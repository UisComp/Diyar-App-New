import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/helper/validator_helper.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/designed_by_footer.dart';
import 'package:diyar_app/feature/auth/controller/register_controller.dart';
import 'package:diyar_app/feature/auth/controller/register_state.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_error_handler.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/feature/auth/view/widgets/register_unit_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Registration, step 3: who the resident is and which unit they own. No
/// password and no project.
class RegisterDetailsScreen extends StatefulWidget {
  const RegisterDetailsScreen({super.key});

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController.get(context);
  }

  void _onState(BuildContext context, RegisterState state) {
    if (state is RegisterSuccessState) {
      context.go(RoutesName.registrationPendingScreen);
    }
    if (state is RegisterFailureState) {
      if (state.mustVerifyAgain) {
        AppFunctions.errorMessage(
          context,
          message: apiErrorMessage(state.result),
        );
        context.go(RoutesName.register, extra: _controller.args.phone);
        return;
      }
      if (_controller.hasInlineErrors) {
        // The server's messages go under their fields.
        formKey.currentState?.validate();
        AppFunctions.errorMessage(
          context,
          message: LocaleKeys.reg_fix_fields.tr(),
        );
        return;
      }
      showAuthError(context, state.result, phone: _controller.args.phone);
    }
  }

  static String? _validateOptionalEmail(String? email) {
    final value = email?.trim() ?? '';
    if (value.isEmpty) return null;
    return RegExp(AppConstants.emailPattern).hasMatch(value)
        ? null
        : LocaleKeys.please_enter_a_valid_email.tr();
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.register_details_title.tr()),
      body: SafeArea(
        child: BlocConsumer<RegisterController, RegisterState>(
          listener: _onState,
          builder: (context, state) {
            final isLoading = state is RegisterLoadingState;
            return Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          16.ph,
                          AppText(
                            LocaleKeys.register_details_message.tr(),
                            style: AppStyle.fontSize14Regular(
                              context,
                            ).copyWith(color: surface.textSecondary),
                          ).paddingSymmetric(horizontal: 16.w),
                          16.ph,
                          AppText(
                            LocaleKeys.verified_number.tr(),
                            style: AppStyle.fontSize14Bold(context),
                          ).paddingSymmetric(horizontal: 16.w),
                          8.ph,
                          PhoneNumberChip(
                            phone: _controller.args.phone,
                            verified: true,
                          ).paddingSymmetric(horizontal: 16.w),
                          24.ph,
                          AuthFieldLabel(
                            title: LocaleKeys.reg_name_title.tr(),
                            hint: LocaleKeys.reg_name_hint.tr(),
                          ),
                          CustomTextFormField(
                            controller: _controller.nameController,
                            hintText: LocaleKeys.reg_name_placeholder.tr(),
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (name) =>
                                _controller.fieldErrors['name'] ??
                                ((name ?? '').trim().isEmpty
                                    ? LocaleKeys.please_enter_valid_name.tr()
                                    : null),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          16.ph,
                          AuthFieldLabel(
                            title: LocaleKeys.email_optional.tr(),
                            hint: LocaleKeys.reg_email_hint.tr(),
                          ),
                          CustomTextFormField(
                            controller: _controller.emailController,
                            hintText: LocaleKeys.reg_email_placeholder.tr(),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                _controller.fieldErrors['email'] ??
                                _validateOptionalEmail(email),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          16.ph,
                          AuthFieldLabel(
                            title: LocaleKeys.reg_units_title.tr(),
                            hint: LocaleKeys.reg_units_hint.tr(),
                          ),
                          for (final (i, unit) in _controller.units.indexed)
                            _UnitCodeRow(
                              key: ObjectKey(unit),
                              index: i,
                              entry: unit,
                              onRemove: _controller.units.length > 1
                                  ? () => _controller.removeUnit(unit)
                                  : null,
                            ),
                          if (_controller.canAddUnit)
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton.icon(
                                onPressed: _controller.addUnit,
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.primaryColor,
                                ),
                                label: AppText(
                                  LocaleKeys.add_another_unit.tr(),
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ).paddingSymmetric(horizontal: 8.w)
                          else
                            AppText(
                              LocaleKeys.reg_units_limit.tr(
                                args: ['${RegisterController.maxUnits}'],
                              ),
                              style: AppStyle.fontSize12Regular(
                                context,
                              ).copyWith(color: surface.textSecondary),
                            ).paddingSymmetric(horizontal: 16.w),
                          16.ph,
                          AuthFieldLabel(
                            title: LocaleKeys.password.tr(),
                            hint: LocaleKeys.reg_password_hint.tr(),
                          ),
                          AuthPasswordField(
                            controller: _controller.passwordController,
                            hintText: LocaleKeys.password.tr(),
                            validator: (value) =>
                                _controller.fieldErrors['password'] ??
                                AuthPasswordField.validatePassword(value),
                          ),
                          12.ph,
                          AuthPasswordField(
                            controller: _controller.confirmationController,
                            hintText: LocaleKeys.password_confirmation.tr(),
                            validator: (value) =>
                                ValidatorHelper.validatePasswordConfirmation(
                                  value,
                                  originalPassword:
                                      _controller.passwordController.text,
                                  emptyMessage: LocaleKeys
                                      .please_enter_your_password
                                      .tr(),
                                  notMatchMessage: LocaleKeys
                                      .passwords_do_not_match
                                      .tr(),
                                ),
                          ),
                          16.ph,
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    buttonHeight: 52.h,
                    buttonText: LocaleKeys.submit_registration.tr(),
                    isLoading: isLoading,
                    buttonColor: AppColors.primaryColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        _controller.submit(locale: context.locale.languageCode);
                      }
                    },
                  ).paddingAll(16.sp),
                  const DesignedByFooter(compact: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// One unit code: "Unit 2", the field, a remove button and the check result.
class _UnitCodeRow extends StatelessWidget {
  const _UnitCodeRow({
    super.key,
    required this.index,
    required this.entry,
    this.onRemove,
  });

  final int index;
  final UnitCodeEntry entry;

  /// Null for the only row: at least one unit is required.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final controller = RegisterController.get(context);
    final surface = AppSurface.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  LocaleKeys.reg_unit_n.tr(args: ['${index + 1}']),
                  style: AppStyle.fontSize12Bold(
                    context,
                  ).copyWith(color: surface.textSecondary),
                ),
              ),
              if (onRemove != null)
                TextButton(
                  onPressed: onRemove,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: AppText(
                    LocaleKeys.remove_unit.tr(),
                    style: const TextStyle(color: AppColors.redColor),
                  ),
                ),
            ],
          ).paddingSymmetric(horizontal: 16.w),
          4.ph,
          CustomTextFormField(
            controller: entry.controller,
            hintText: LocaleKeys.unit_code_hint.tr(),
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(
                RegisterController.maxCodeLength,
              ),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (code) {
              if (entry.serverError != null) return entry.serverError;
              if ((code ?? '').trim().isEmpty) {
                return LocaleKeys.please_enter_unit_code.tr();
              }
              if (controller.isDuplicate(entry)) {
                return LocaleKeys.reg_unit_duplicate.tr();
              }
              return null;
            },
            prefixIcon: const Icon(Icons.domain),
          ),
        ],
      ),
    );
  }
}
