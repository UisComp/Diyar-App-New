import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/documents/controller/documents_state.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';
import 'package:diyar_app/feature/documents/service/documents_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DocumentsController extends Cubit<DocumentsState> {
  DocumentsController() : super(const DocumentsInitialState());

  static DocumentsController get(BuildContext context) =>
      BlocProvider.of<DocumentsController>(context);

  DocumentsResponseModel documentsResponseModel = DocumentsResponseModel();

  Future<void> getDocuments() async {
    emit(const GetDocumentsLoadingState());
    try {
      final response = await DocumentsService.getDocuments();
      documentsResponseModel = response;
      if (response.success == true) {
        emit(const GetDocumentsSuccessState());
      } else {
        AppLogger.error("Error While Get Documents: ${response.message}");
        emit(GetDocumentsFailureState(errorMessage: response.message));
      }
    } catch (e) {
      AppLogger.error("Error While Get Documents: $e");
      emit(GetDocumentsFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> previewFile(String url) async {
    emit(PreviewFileLoadingState(fileUrl: url));
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/${url.split('/').last}";

      if (!File(filePath).existsSync()) {
        await Dio().download(url, filePath);
      }
      await OpenFilex.open(filePath);
      emit(const PreviewFileSuccessState());
    } catch (e) {
      AppLogger.error("Error previewing file: $e");
      emit(PreviewFileFailureState(errorMessage: e.toString()));
    }
  }

  /// Android saves to the public Downloads folder. iOS saves to the app's
  /// Documents folder, which is visible in the Files app (file sharing is
  /// enabled in Info.plist).
  Future<Directory> _downloadDirectory() async {
    if (Platform.isAndroid) {
      final downloads = Directory("/storage/emulated/0/Download");
      if (downloads.existsSync()) return downloads;
      final external = await getExternalStorageDirectory();
      if (external != null) return external;
    }
    return getApplicationDocumentsDirectory();
  }

  Future<void> downloadFileWithProgress(String url) async {
    emit(DownloadFileProgressState(fileUrl: url, progress: 0));
    try {
      final directory = await _downloadDirectory();
      final filePath = "${directory.path}/${url.split('/').last}";
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            emit(
              DownloadFileProgressState(
                fileUrl: url,
                progress: (received / total) * 100,
              ),
            );
          }
        },
      );
      AppLogger.success("File downloaded to: $filePath");
      emit(const DownloadFileSuccessState());
    } catch (e) {
      AppLogger.error("Error downloading file: $e");
      emit(DownloadFileFailureState(errorMessage: e.toString()));
    }
  }
}
