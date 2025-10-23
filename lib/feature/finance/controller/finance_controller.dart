import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FinanceController extends Cubit<FinanceState> {
  FinanceController() : super(FinanceInitial());
  static FinanceController get(BuildContext context) =>
      BlocProvider.of<FinanceController>(context);

  Future<void> previewFile(String url) async {
    emit(PriviewFileLoadingState());
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/${url.split('/').last}";

      if (!File(filePath).existsSync()) {
        await Dio().download(url, filePath);
      }
      await OpenFilex.open(filePath);
      emit(PriviewFileSuccessState());
    } catch (e) {
      AppLogger.error("Error previewing file: $e");
      emit(PriviewFileFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> downloadFile(String url) async {
    emit(DownloadFileLoadingState());
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/${url.split('/').last}";

      await Dio().download(url, filePath);
      AppLogger.info("File downloaded to $filePath");
      emit(DownloadFileSuccessState());
    } catch (e) {
      AppLogger.error("Error downloading file: $e");
      emit(DownloadFileFailureState(errorMessage: e.toString()));
    }
  }
}
