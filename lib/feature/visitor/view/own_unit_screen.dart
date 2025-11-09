import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:diyar_app/feature/visitor/view/widgets/qr_code_view.dart';
import 'package:diyar_app/feature/visitor/view/widgets/start_time_and_end_time_fields.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocConsumer<VisitorController, VisitorState>(
      listener: (context, visitorState) {
        if (visitorState is CreateVisitorPassErrorState) {
          AppFunctions.errorMessage(
            context,
            message:
                visitorState.message ??
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
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.select_your_unit.tr(),
                  style: AppStyle.fontSize22Bold(context),
                ).paddingSymmetric(horizontal: 16.w),
                8.ph,
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: visitorController.selectedUnitId,
                  decoration: InputDecoration(
                    fillColor: darkTheme
                        ? Colors.black45
                        : AppColors.secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  hint: Text(LocaleKeys.choose_a_linked_unit.tr()),
                  items:
                      profileController.userLinkedUnitsResponseModel.data
                          ?.map<DropdownMenuItem<String>>((unit) {
                            return DropdownMenuItem(
                              value: unit.id.toString(),
                              child: Text(unit.name ?? ""),
                            );
                          })
                          .toList() ??
                      [],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.please_select_a_unit.tr();
                    }
                    return null;
                  },
                  onChanged: visitorController.onUnitChanged,
                ).paddingSymmetric(horizontal: 16.w),

                15.ph,
                Text(
                  LocaleKeys.select_date_range.tr(),
                  style: AppStyle.fontSize16Regular(context),
                ).paddingSymmetric(horizontal: 16.w),
                8.ph,
                CustomTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: visitorController.dateRangeController,
                  readOnly: true,
                  onTap: () async {
                    await visitorController.pickDateRange(context);
                    if (visitorController.selectedDateRange != null) {
                      visitorController.dateRangeController.text =
                          "${AppFormatter.dateFormatter().format(visitorController.selectedDateRange!.start)} → ${DateFormat('MMM d, yyyy').format(visitorController.selectedDateRange!.end)}";
                    }
                  },
                  validator: (value) {
                    if (visitorController.selectedDateRange == null) {
                      return LocaleKeys.please_select_date_range.tr();
                    }
                    return null;
                  },
                  hintText: LocaleKeys.select_date_range.tr(),
                ),
                15.ph,
                Text(
                  LocaleKeys.select_time_range.tr(),
                  style: AppStyle.fontSize16Regular(context),
                ).paddingSymmetric(horizontal: 16.w),
                8.ph,
                StartTimeAndEndTimeFields(visitorController: visitorController),
                32.ph,
                CustomButton(
                  isLoading: visitorState is CreateVisitorPassLoadingState,
                  buttonText: LocaleKeys.generate_qr.tr(),
                  buttonColor: AppColors.primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await visitorController.createVisitorPass();
                    }
                  },
                ).paddingSymmetric(horizontal: 16.w),
                32.ph,
                if (visitorController.generatedQrData != null)
                  QrCodeView(visitorController: visitorController),
              ],
            ),
          ),
        );
      },
    );
  }
}
