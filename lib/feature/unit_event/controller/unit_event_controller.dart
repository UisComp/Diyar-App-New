import 'dart:developer';

import 'package:diyar_app/core/model/news_response_model.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_state.dart';
import 'package:diyar_app/feature/unit_event/service/unit_event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitEventController extends Cubit<UnitEventState> {
  UnitEventController() : super(UnitEventInitial());
  static UnitEventController get(BuildContext context) =>
      BlocProvider.of(context);
  NewsResponseModel newsResponseModel = NewsResponseModel();
  Future<void> getUnitsByEvent({required String id}) async {
    emit(GetUnitsByEventLoadingState());
    try {
      await UnitEventService.getUnitsByEvent(id: id).then((newsResponse) {
        newsResponseModel = newsResponse;
        emit(GetUnitsByEventSuccessfullyState());
      });
    } catch (e) {
      log('Error Happen While Get Units By Event is $e');
      emit(GetUnitsByEventErrorState(error: e.toString()));
    }
  }
}
