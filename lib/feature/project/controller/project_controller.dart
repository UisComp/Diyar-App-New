import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';
import 'package:diyar_app/feature/project/service/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectController extends Cubit<ProjectState> {
  ProjectController() : super(ProjectInitialState());
  static ProjectController get(BuildContext context) =>
      BlocProvider.of(context);
  ProjectsResponseModel projectsResponseModel = ProjectsResponseModel();
  ProjectDetailsResponseModel projectDetailsResponseModel =
      ProjectDetailsResponseModel();
  Future<void> getProjects() async {
    emit(GetProjectsLoadingState());
    await ProjectService.getProjects()
        .then((value) {
          projectsResponseModel = value;
          if (value.success == true) {
            AppLogger.success('projectsResponseModel: ${projectsResponseModel.toJson()}');
            emit(GetProjectsSuccessfullyState());
          } else {
            emit(GetProjectsFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get Projects is $error');
          emit(GetProjectsFailureState(error: error.toString()));
        });
  }

  Future<void> getProjectDetails({required String id}) async {
    emit(GetProjectDetailsLoadingState());
    await ProjectService.getProjectDetails(id: id)
        .then((value) {
          projectDetailsResponseModel = value;
          AppLogger.info(
            'projectDetailsResponseModel: ${projectDetailsResponseModel.toJson()}',
          );
          if (value.success == true) {
            emit(GetProjectDetailsSuccessfullyState());
          } else {
            emit(GetProjectDetailsFailureState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get Project Details is $error');
          emit(GetProjectDetailsFailureState(error: error.toString()));
        });
  }
}
