import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:diyar_app/feature/visitor/view/widgets/qr_code_view.dart';
import 'package:diyar_app/feature/visitor/view/widgets/start_time_and_end_time_fields.dart';
import 'package:diyar_app/feature/visitor/view/widgets/unit_dropdown_field.dart';
import 'package:diyar_app/feature/visitor/view/widgets/visitor_form_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnUnitScreen extends StatefulWidget {
  const OwnUnitScreen({super.key});

  @override
  State<OwnUnitScreen> createState() => _OwnUnitScreenState();
}

class _OwnUnitScreenState extends State<OwnUnitScreen> {
  late ProfileController profileController;
  late VisitorController visitorController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profileController = ProfileController.get(context);
    visitorController = VisitorController.get(context);
    visitorController.clearData();
    profileController.getUserLinkedUnits();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VisitorController, VisitorState>(
      listener: (context, visitorState) {
        if (visitorState is CreateVisitorPassErrorState) {
          AppFunctions.errorMessage(
            context,
            message:
                visitorState.message?.removeExceptionWord() ??
                LocaleKeys.failed_to_create_visitor_pass.tr(),
          );
        }
        if (visitorState is CreateVisitorPassSuccessState) {
          AppFunctions.successMessage(
            context,
            message: LocaleKeys.visitor_pass_created_successfully.tr(),
          );
        }
      },
      builder: (context, visitorState) {
        final bool isGenerating =
            visitorState is CreateVisitorPassLoadingState;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                20.ph,
                VisitorSectionCard(
                  title: LocaleKeys.visit_details.tr(),
                  children: [
                    VisitorFieldLabel(
                      icon: Icons.home_work_outlined,
                      label: LocaleKeys.select_your_unit.tr(),
                    ),
                    8.ph,
                    UnitDropdownField(
                      profileController: profileController,
                      visitorController: visitorController,
                    ),
                    18.ph,
                    VisitorFieldLabel(
                      icon: Icons.calendar_month_outlined,
                      label: LocaleKeys.select_date_range.tr(),
                    ),
                    8.ph,
                    _buildDateRangeField(context),
                    18.ph,
                    VisitorFieldLabel(
                      icon: Icons.schedule_outlined,
                      label: LocaleKeys.select_time_range.tr(),
                    ),
                    8.ph,
                    StartTimeAndEndTimeFields(
                      visitorController: visitorController,
                    ),
                    if (_hasCompleteWindow) ...[
                      16.ph,
                      _buildValidWindowSummary(context),
                    ],
                  ],
                ),
                20.ph,
                CustomButton(
                  isLoading: isGenerating,
                  buttonText: LocaleKeys.generate_qr.tr(),
                  buttonColor: AppColors.primaryColor,
                  onPressed: _onGeneratePressed,
                ),
                24.ph,
                if (visitorController.generatedQrData != null)
                  QrCodeView(visitorController: visitorController)
                else
                  VisitorNoteBanner(
                    icon: Icons.qr_code_2_rounded,
                    message: LocaleKeys.qr_placeholder_hint.tr(),
                  ),
                16.ph,
                AppText(
                  LocaleKeys.qr_validity_note.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.fontSize12Regular(context).copyWith(
                    color: VisitorFormTheme.hint(context),
                    height: 1.5,
                  ),
                ).paddingSymmetric(horizontal: 8.w),
              ],
            ),
          ),
        );
      },
    );
  }

  bool get _hasCompleteWindow =>
      visitorController.selectedDateRange != null &&
      visitorController.startTime != null &&
      visitorController.endTime != null;

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          LocaleKeys.select_your_unit.tr(),
          style: AppStyle.fontSize22Bold(context),
        ),
        6.ph,
        AppText(
          LocaleKeys.visitor_pass_subtitle.tr(),
          style: AppStyle.fontSize14Regular(
            context,
          ).copyWith(color: VisitorFormTheme.hint(context)),
        ),
      ],
    );
  }

  Widget _buildDateRangeField(BuildContext context) {
    return CustomTextFormField(
      horizontalPadding: 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: visitorController.dateRangeController,
      readOnly: true,
      hintText: LocaleKeys.select_date_range.tr(),
      prefixIcon: Icon(
        Icons.calendar_month_outlined,
        size: 20.sp,
        color: AppColors.primaryColor,
      ),
      suffixIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 24.sp,
        color: AppColors.primaryColor,
      ),
      validator: (_) => visitorController.selectedDateRange == null
          ? LocaleKeys.please_select_date_range.tr()
          : null,
      onTap: () async {
        await visitorController.pickDateRange(context);
        final range = visitorController.selectedDateRange;
        if (range != null) {
          visitorController.dateRangeController.text =
              "${AppFormatter.dateFormatter().format(range.start)} → "
              "${AppFormatter.dateFormatter().format(range.end)}";
        }
      },
    );
  }

  /// Compact recap of the selected window, so the user can confirm the pass
  /// before generating it.
  Widget _buildValidWindowSummary(BuildContext context) {
    final range = visitorController.selectedDateRange!;
    final dates =
        "${AppFormatter.dateFormatter().format(range.start)} → "
        "${AppFormatter.dateFormatter().format(range.end)}";
    final times =
        "${visitorController.startTime!.format(context)} - "
        "${visitorController.endTime!.format(context)}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: VisitorFormTheme.field(context),
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_outlined,
            size: 20.sp,
            color: AppColors.primaryColor,
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  LocaleKeys.valid_window.tr(),
                  style: AppStyle.fontSize12Bold(
                    context,
                  ).copyWith(color: VisitorFormTheme.hint(context)),
                ),
                4.ph,
                AppText(
                  "$dates  •  $times",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.fontSize14Bold(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onGeneratePressed() async {
    if (!_formKey.currentState!.validate()) return;
    if (userModel?.data?.accessToken == null) {
      AppFunctions.warningMessage(
        context,
        message: LocaleKeys.available_for_logged_in_users_only.tr(),
      );
      return;
    }
    await visitorController.createVisitorPass();
  }
}
