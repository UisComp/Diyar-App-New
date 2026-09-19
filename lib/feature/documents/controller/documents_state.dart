sealed class DocumentsState {
  const DocumentsState();
}

class DocumentsInitialState extends DocumentsState {
  const DocumentsInitialState();
}

class GetDocumentsLoadingState extends DocumentsState {
  const GetDocumentsLoadingState();
}

class GetDocumentsSuccessState extends DocumentsState {
  const GetDocumentsSuccessState();
}

class GetDocumentsFailureState extends DocumentsState {
  final String? errorMessage;
  const GetDocumentsFailureState({this.errorMessage});
}

class PreviewFileLoadingState extends DocumentsState {
  final String fileUrl;
  const PreviewFileLoadingState({required this.fileUrl});
}

class PreviewFileSuccessState extends DocumentsState {
  const PreviewFileSuccessState();
}

class PreviewFileFailureState extends DocumentsState {
  final String? errorMessage;
  const PreviewFileFailureState({this.errorMessage});
}

class DownloadFileProgressState extends DocumentsState {
  final String fileUrl;
  final double progress;
  const DownloadFileProgressState({
    required this.fileUrl,
    required this.progress,
  });
}

class DownloadFileSuccessState extends DocumentsState {
  const DownloadFileSuccessState();
}

class DownloadFileFailureState extends DocumentsState {
  final String? errorMessage;
  const DownloadFileFailureState({this.errorMessage});
}
