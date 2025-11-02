import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
    bool isScanning = false;
  String? scannedCode;

  final MobileScannerController scannerController = MobileScannerController(
      autoStart: false,
    detectionSpeed: DetectionSpeed.normal,
    formats: [
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.itf,
      BarcodeFormat.pdf417,
      BarcodeFormat.codebar,
      BarcodeFormat.all,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.upcA,
    ],
  );

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

  void generateQr() {
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

    final startDate = AppFormatter.dateFormatter().format(
      selectedDateRange!.start,
    );
    final endDate = AppFormatter.dateFormatter().format(selectedDateRange!.end);

    final formattedStartTime =
        "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}";
    final formattedEndTime =
        "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}";

    generatedQrData =
        "https://yourapp.com/unit-access?unit=$selectedUnitId&startDate=$startDate&endDate=$endDate&startTime=$formattedStartTime&endTime=$formattedEndTime";

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
    dateRangeController.clear();
    startTimeController.clear();
    endTimeController.clear();
    selectedDateRange = null;
    startTime = null;
    endTime = null;

    emit(ClearDataState());
  }
   void startScan() {
     isScanning = true;
     scannerController.start();
     emit(StartScanState());
  }

  void stopScan() {
     isScanning = false;
    scannerController.stop();
    emit(StopScanState());
  }

}
