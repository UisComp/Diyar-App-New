import 'dart:io';
import 'dart:ui';

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
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
                              child: Text(unit.name ?? "Unnamed Unit"),
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        controller: visitorController.startTimeController,
                        readOnly: true,
                        onTap: () async {
                          await visitorController.pickStartTime(context);
                          if (visitorController.startTime != null) {
                            visitorController.startTimeController.text =
                                visitorController.startTime!.format(context);
                          }
                        },
                        validator: (value) {
                          if (visitorController.startTime == null) {
                            return LocaleKeys.please_select_time_range.tr();
                          }
                          return null;
                        },
                        hintText: LocaleKeys.start_time.tr(),
                      ),
                    ),
                    16.pw,
                    Expanded(
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: visitorController.endTimeController,
                        readOnly: true,
                        onTap: () async {
                          await visitorController.pickEndTime(context);
                          if (visitorController.endTime != null) {
                            visitorController.endTimeController.text =
                                visitorController.endTime!.format(context);
                          }
                        },
                        validator: (value) {
                          if (visitorController.endTime == null) {
                            return LocaleKeys.please_select_time_range.tr();
                          }
                          return null;
                        },
                        hintText: LocaleKeys.end_time.tr(),
                      ),
                    ),
                  ],
                ),
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
                  Column(
                    children: [
                      Text(
                        LocaleKeys.your_qr_code.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      16.ph,
                      QrImageView(
                        data: visitorController.generatedQrData!,
                        version: QrVersions.auto,
                        size: 200.sp,
                        backgroundColor: Colors.white,
                      ),
                      20.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                            tooltip: LocaleKeys.share_qr_code.tr(),
                            onPressed: () async {
                              try {
                                final qrData =
                                    visitorController.generatedQrData!;

                                final qrValidationResult = QrValidator.validate(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                                );

                                if (qrValidationResult.status ==
                                    QrValidationStatus.valid) {
                                  final painter = QrPainter.withQr(
                                    qr: qrValidationResult.qrCode!,
                                    color: Colors.black,
                                    emptyColor: Colors.white,
                                  );

                                  final tempDir = await getTemporaryDirectory();
                                  final file = File(
                                    "${tempDir.path}/qr_code.png",
                                  );

                                  final picData = await painter.toImageData(
                                    2048,
                                    format: ImageByteFormat.png,
                                  );
                                  await file.writeAsBytes(
                                    picData!.buffer.asUint8List(),
                                  );

                                  await Share.shareXFiles(
                                    [XFile(file.path)],
                                    subject: LocaleKeys.share_qr_code.tr(),
                                    text: LocaleKeys.your_qr_code.tr(),
                                  );
                                }
                              } catch (e) {
                                debugPrint("QR share error: $e");
                              }
                            },
                          ),
                          Text(
                            LocaleKeys.share_qr_code.tr(),
                            style: AppStyle.fontSize16Regular(context),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16.w),
                    ],
                  ).paddingSymmetric(horizontal: 16.w),
              ],
            ),
          ),
        );
      },
    );
  }
}
