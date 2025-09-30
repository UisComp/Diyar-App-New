import 'dart:developer';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/model/project_details_response.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';
import 'package:diyar_app/feature/project/service/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectController extends Cubit<ProjectState> {
  ProjectController() : super(ProjectInitialState());
  static ProjectController get(BuildContext context) =>
      BlocProvider.of(context);
  ProjectsResponseModel projectsResponseModel = ProjectsResponseModel();
  ProjectDetailsResponse projectDetailsResponseModel = ProjectDetailsResponse();
  Future<void> getProjects() async {
    emit(GetProjectsLoadingState());
    await ProjectService.getProjects()
        .then((value) {
          projectsResponseModel = value;
          emit(GetProjectsSuccessfullyState());
        })
        .catchError((error) {
          log('Error Happen While Get Projects is $error');
          emit(GetProjectsFailureState(error: error.toString()));
        });
  }

  Future<void> getProjectDetails({required String id}) async {
    emit(GetProjectDetailsLoadingState());
    await ProjectService.getProjectDetails(id: id)
        .then((value) {
          projectDetailsResponseModel = value;
          emit(GetProjectDetailsSuccessfullyState());
        })
        .catchError((error) {
          log('Error Happen While Get Projects is $error');
          emit(GetProjectDetailsFailureState(error: error.toString()));
        });
  }
}
