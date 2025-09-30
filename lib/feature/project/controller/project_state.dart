abstract class ProjectState {}

class ProjectInitialState extends ProjectState {}

class GetProjectsLoadingState extends ProjectState {}

class GetProjectsSuccessfullyState extends ProjectState {}

class GetProjectsFailureState extends ProjectState {
  final String? error;
  GetProjectsFailureState({this.error});
}

class GetProjectDetailsLoadingState extends ProjectState {}

class GetProjectDetailsSuccessfullyState extends ProjectState {}

class GetProjectDetailsFailureState extends ProjectState {
  final String? error;
  GetProjectDetailsFailureState({this.error});
}
