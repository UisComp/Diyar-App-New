import 'dart:developer';

import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/model/user_services_model.dart';
import 'package:diyar_app/feature/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(HomeInitial());
  static HomeController get(BuildContext context) => BlocProvider.of(context);
  int currentIndex = 1;
  void changeIndexBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeIndexBottomNavBarState());
  }

  UserServicesResponse userServicesResponse = UserServicesResponse();
  Future<void> getAllServices() async {
    emit(GetAllServicesLoadingState());
    await HomeService.getAllServices()
        .then((value) {
          userServicesResponse = value;
          log('getAllServices==> ${value.data}');
          log('getAllServices==> ${value.data?.length}');
          if (value.success == true) {
            emit(GetAllServicesSuccessfullyState());
          } else {
            emit(GetAllServicesErrorState(error: value.message));
          }
        })
        .catchError((error) {
          log('Error Happen While Get All Services is $error');
          emit(GetAllServicesErrorState(error: error.toString()));
        });
  }
}
