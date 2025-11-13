import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:diyar_app/feature/visitor/model/scan_qr_code_response_model.dart';
import 'package:diyar_app/feature/visitor/model/visitor_pass_request.dart';
import 'package:diyar_app/feature/visitor/model/visitor_pass_response.dart';
import 'package:diyar_app/feature/visitor/service/visitor_service.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VisitorController extends Cubit<VisitorState> {
  VisitorController() : super(VisitorInitial());
  static VisitorController get(BuildContext context) =>
      BlocProvider.of<VisitorController>(context);
  String? selectedUnitId;
  String? generatedQrData;
  DateTimeRange? selectedDateRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  Future<void> pickDateRange(BuildContext context) async {
    emit(PickDateRangeLoadingState());
    try {
      final now = DateTime.now();
      final picked = await showDateRangePicker(
        context: context,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
        initialDateRange:
            selectedDateRange ??
            DateTimeRange(start: now, end: now.add(const Duration(days: 1))),
      );

      if (picked != null) {
        selectedDateRange = picked;
        dateRangeController.text =
            "${AppFormatter.dateFormatter().format(picked.start)} → ${AppFormatter.dateFormatter().format(picked.end)}";

        emit(PickDateRangeSelected());
      } else {
        emit(PickDateRangeCancelled());
      }
    } catch (e) {
      emit(PickDateRangeError(message: "Failed to pick date range: $e"));
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    emit(PickStartTimeLoading());
    try {
      final picked = await showTimePicker(
        context: context,
        initialTime: startTime ?? TimeOfDay.now(),
      );

      if (picked != null) {
        startTime = picked;
        startTimeController.text = picked.format(context);
        emit(PickStartTimeSelected());
      } else {
        emit(PickStartTimeCancelled());
      }
    } catch (e) {
      emit(PickStartTimeError(message: "Failed to pick start time: $e"));
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    emit(PickEndTimeLoading());
    try {
      final picked = await showTimePicker(
        context: context,
        initialTime: endTime ?? TimeOfDay.now(),
      );

      if (picked != null) {
        endTime = picked;
        endTimeController.text = picked.format(context);
        emit(PickEndTimeSelected());
      } else {
        emit(PickEndTimeCancelled());
      }
    } catch (e) {
      emit(PickEndTimeError(message: "Failed to pick end time: $e"));
    }
  }

  Future<void> generateQr() async {
    emit(GeneratingQrState());

    if (selectedUnitId == null ||
        selectedDateRange == null ||
        startTime == null ||
        endTime == null) {
      emit(
        EmptyQrState("Please select all required fields before generating QR."),
      );
      return;
    }

    if (visitorPassResponse.data?.token == null) {
      emit(
        EmptyQrState(
          "Token not available. Please create a visitor pass first.",
        ),
      );
      return;
    }

    final startDate = AppFormatter.dateFormatter().format(
      selectedDateRange!.start,
    );
    final endDate = AppFormatter.dateFormatter().format(selectedDateRange!.end);
    // final formattedStartTime =
    //     "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}";
    // final formattedEndTime =
    //     "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}";
    final formattedStartTime = AppFormatter.formatUtcTime(startTime!);
    final formattedEndTime = AppFormatter.formatUtcTime(endTime!);

    generatedQrData =
        "https://yourapp.com/unit-access?token=${visitorPassResponse.data?.token}"
        "&unit=$selectedUnitId"
        "&startDate=$startDate"
        "&endDate=$endDate"
        "&startTime=$formattedStartTime"
        "&endTime=$formattedEndTime";
    AppLogger.log("Generated QR: $generatedQrData");
    emit(QrGeneratedState());
  }

  void disposeControllers() {
    dateRangeController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }

  void onUnitChanged(String? unitId) {
    selectedUnitId = unitId;
    selectedDateRange = null;
    startTime = null;
    endTime = null;
    dateRangeController.clear();
    startTimeController.clear();
    endTimeController.clear();

    emit(UnitChangedState());
  }

  void clearData() {
    generatedQrData = null;
    selectedUnitId = null;
    dateRangeController.clear();
    startTimeController.clear();
    endTimeController.clear();
    selectedDateRange = null;
    startTime = null;
    endTime = null;

    emit(ClearDataState());
  }

  VisitorPassResponse visitorPassResponse = VisitorPassResponse();

  Future<void> createVisitorPass() async {
    try {
      emit(CreateVisitorPassLoadingState());
      await VisitorService.createVisitorPass(
            visitorPassRequest: VisitorPassRequest(
              isOneTimeUse: false,
              endDate: AppFormatter.dateFormatter().format(
                selectedDateRange!.end,
              ),
              startDate: AppFormatter.dateFormatter().format(
                selectedDateRange!.start,
              ),
              startTime: AppFormatter.formatUtcTime(startTime!),
              endTime: AppFormatter.formatUtcTime(endTime!),

              // startTime: AppFormatter.formatTime(startTime!),
              // endTime: AppFormatter.formatTime(endTime!),
              unitId: int.tryParse(selectedUnitId.toString()),
            ),
          )
          .then((value) async {
            visitorPassResponse = value;

            if (value.success == true) {
              await generateQr();
              AppLogger.success(
                'visitor Pass Response ${visitorPassResponse.toJson()}',
              );
              emit(CreateVisitorPassSuccessState());
            }
          })
          .catchError((error) {
            AppLogger.error('Error Happen While Create Visitor Pass is $error');
            emit(
              CreateVisitorPassErrorState(
                message: "Failed to create visitor pass: $error",
              ),
            );
          });
    } catch (e) {
      emit(
        CreateVisitorPassErrorState(
          message: "Failed to create visitor pass: $e",
        ),
      );
    }
  }

  String? extractToken(String? scannedCode) {
    try {
      if (scannedCode == null) return null;
      final uri = Uri.parse(scannedCode);
      final token = uri.queryParameters["token"];
      AppLogger.log("Token: $token");
      return token;
    } catch (e) {
      AppLogger.error("extractToken error: $e");
      return null;
    }
  }

  String mapScanErrorMessage(String? message) {
    switch (message) {
      case "Visitor pass not found.":
        return LocaleKeys.visitor_pass_not_found.tr();

      case "Visitor pass has been revoked.":
        return LocaleKeys.visitor_pass_revoked.tr();

      case "Visitor pass is not yet valid.":
        return LocaleKeys.visitor_pass_not_yet_valid.tr();

      case "Visitor pass has expired.":
        return LocaleKeys.visitor_pass_expired.tr();

      case "This one-time visitor pass has already been used.":
        return LocaleKeys.visitor_pass_one_time_used.tr();

      default:
        return message ?? '';
    }
  }

  ScanQrCodeResponseModel scanQrCodeResponseModel = ScanQrCodeResponseModel();
  Future<void> scanQrCodeRequest(String? scannedCode) async {
    emit(ScanQrRequestLoadingState());
    final token = extractToken(scannedCode);
    if (token == null) {
      AppLogger.error("Token not found$token");
      emit(
        ScanQrRequestErrorState(message: "Invalid QR — token not found$token"),
      );
      return;
    }
    try {
      final scan = await VisitorService.scanQrCode(token: token);
      scanQrCodeResponseModel = scan;

      if (scan.success == true && scan.data?.valid == true) {
        emit(ScanQrRequestSuccessState());
      } else {
        final mappedMessage = mapScanErrorMessage(scan.message);

        AppLogger.error("error while scanning $mappedMessage");
        emit(ScanQrRequestErrorState(message: mappedMessage));
      }
    } catch (e) {
      AppLogger.error("error while scanning $e");
      emit(ScanQrRequestErrorState(message: "Failed to scan QR: $e"));
    }
  }
}
