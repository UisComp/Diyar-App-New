import 'dart:developer';
import 'package:diyar_app/feature/unit_event/controller/unit_event_state.dart';
import 'package:diyar_app/feature/unit_event/model/news_by_project_unit_event_response_model.dart';
import 'package:diyar_app/feature/unit_event/service/unit_event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitEventController extends Cubit<UnitEventStates> {
  UnitEventController() : super(UnitEventInitial());
  static UnitEventController get(BuildContext context) =>
      BlocProvider.of(context);

  NewByProjectUnitEventResponseModel newByProjectUnitEventResponseModel =
      NewByProjectUnitEventResponseModel();
  Future<void> getUnitsByEvent({required String id}) async {
    emit(GetUnitsByEventLoadingState());
    try {
      await UnitEventService.getNewsByProjectUnitsByEvent(id: id).then((
        newByProjectUnitEvent,
      ) {
        newByProjectUnitEventResponseModel = newByProjectUnitEvent;
        if (newByProjectUnitEventResponseModel.success == true) {
          emit(GetUnitsByEventSuccessfullyState());
        } else {
          emit(
            GetUnitsByEventErrorState(
              error: newByProjectUnitEventResponseModel.message,
            ),
          );
        }
      });
    } catch (e) {
      log('Error Happen While Get Units By Event is $e');
      emit(GetUnitsByEventErrorState(error: e.toString()));
    }
  }
}
