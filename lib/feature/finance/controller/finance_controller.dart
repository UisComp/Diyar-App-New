import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/documents_response_model.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/service/finance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FinanceController extends Cubit<FinanceState> {
  FinanceController() : super(const FinanceState.initial());

  static FinanceController get(BuildContext context) =>
      BlocProvider.of<FinanceController>(context);

  Future<void> previewFile(String url) async {
    emit(const FinanceState.previewFileLoading());
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/${url.split('/').last}";

      if (!File(filePath).existsSync()) {
        await Dio().download(url, filePath);
      }
      await OpenFilex.open(filePath);
      emit(const FinanceState.previewFileSuccess());
    } catch (e) {
      AppLogger.error("Error previewing file: $e");
      emit(FinanceState.previewFileFailure(errorMessage: e.toString()));
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied ||
          await Permission.videos.isDenied ||
          await Permission.audio.isDenied ||
          await Permission.manageExternalStorage.isDenied ||
          await Permission.storage.isDenied) {
        var result = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
          Permission.manageExternalStorage,
          Permission.storage,
        ].request();
        return result.values.every((e) => e.isGranted);
      }
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }

  // Future<void> downloadFile(String url) async {
  //   emit(const FinanceState.downloadFileLoading());

  //   try {
  //     final dir = await getApplicationDocumentsDirectory();
  //     final filename = url.split('/').last;
  //     final filePath = "${dir.path}/$filename";

  //     await Dio().download(url, filePath);

  //     OpenFilex.open(filePath);
  //     emit(const FinanceState.downloadFileSuccess());
  //   } catch (e) {
  //     emit(FinanceState.downloadFileFailure(errorMessage: e.toString()));
  //   }
  // }

  // Future<void> downloadFileWithProgress(String url) async {
  //   emit(const FinanceState.downloadFileLoading());

  //   try {
  //     // final dir = await getApplicationDocumentsDirectory();
  //     final dir = await getExternalStorageDirectory();
  //     final filename = url.split('/').last;
  //     final filePath = "${dir?.path}/$filename";
  //     final dio = Dio();

  //     await dio.download(
  //       url,
  //       filePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           final progress = (received / total) * 100;
  //           emit(FinanceState.downloadFileProgress(
  //             fileUrl: url,
  //             progress: progress,
  //           ));
  //         }
  //       },
  //     );
  // AppLogger.success("Downloaded File dir: $dir");
  // AppLogger.success("Downloaded File path: $filePath");
  //     emit(const FinanceState.downloadFileSuccess());
  //   } catch (e) {
  //     emit(FinanceState.downloadFileFailure(errorMessage: e.toString()));
  //   }
  // }
  Future<void> downloadFileWithProgress(String url) async {
    emit(const FinanceState.downloadFileLoading());

    try {
      Directory directory = Directory("/storage/emulated/0/Download");
      if (!directory.existsSync()) {
        directory =
            await getExternalStorageDirectory() ??
            Directory("/storage/emulated/0/Download");
      }

      final filename = url.split('/').last;
      final filePath = "${directory.path}/$filename";
      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total) * 100;
            emit(
              FinanceState.downloadFileProgress(
                fileUrl: url,
                progress: progress,
              ),
            );
          }
        },
      );
      AppLogger.success(" Download Directory: $directory");
      AppLogger.success(" File Path: $filePath");
      emit(const FinanceState.downloadFileSuccess());
    } catch (e) {
      emit(FinanceState.downloadFileFailure(errorMessage: e.toString()));
    }
  }

  FinanceResponseModel financeResponseModel = FinanceResponseModel();
  Future<void> getFinance() async {
    emit(const FinanceState.getFinanceLoading());
    try {
      await FinanceService.getFinance().then((financeResponse) {
        financeResponseModel = financeResponse;
        if (financeResponse.success == true) {
          AppLogger.success(
            "Get Finance: ${financeResponse.data?.units?.map((e) => e.installments?.map((e) => e.status).toList()).toList()}",
          );
          emit(const FinanceState.getFinanceSuccess());
        } else {
          AppLogger.error(
            "Error While Get Finance: ${financeResponse.message}",
          );
          emit(
            FinanceState.getFinanceFailure(
              errorMessage: financeResponse.message,
            ),
          );
        }
      });
    } catch (e) {
      AppLogger.error("Error While Get Finance: $e");
      emit(FinanceState.getFinanceFailure(errorMessage: e.toString()));
    }
  }

  DocumentsResponseModel documentsResponseModel = DocumentsResponseModel();
  Future<void> getDocumets() async {
    emit(const FinanceState.getDocumentsLoading());
    try {
      await FinanceService.getDocuments().then((doucResponse) {
        documentsResponseModel = doucResponse;
        if (doucResponse.success == true) {
          AppLogger.success("Get Documents: ${doucResponse.toJson()}");
          emit(const FinanceState.getDocumentsSuccess());
        } else {
          AppLogger.error("Error While Get Documents: ${doucResponse.message}");
          emit(
            FinanceState.getDocumentsFailure(
              errorMessage: doucResponse.message,
            ),
          );
        }
      });
    } catch (e) {
      AppLogger.error("Error While Get Documents: $e");
      emit(FinanceState.getDocumentsFailure(errorMessage: e.toString()));
    }
  }
}
