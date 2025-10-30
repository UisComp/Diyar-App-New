import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/home/model/user_services_model.dart';
import 'package:diyar_app/feature/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(HomeInitial());
  static HomeController get(BuildContext context) => BlocProvider.of(context);
  int currentIndex = 1;
  final TextEditingController searchController = TextEditingController();

  void changeIndexBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeIndexBottomNavBarState());
  }

  UserServicesResponse userServicesResponse = UserServicesResponse();
  List<UserServiceData> filteredServices = [];
  Future<void> getAllServices() async {
    emit(GetAllServicesLoadingState());
    await HomeService.getAllServices()
        .then((value) {
          userServicesResponse = value;
          AppLogger.success('getAllServices==> ${value.data}');
          AppLogger.success('getAllServices==> ${value.data?.length}');
          if (value.success == true) {
            emit(GetAllServicesSuccessfullyState());
          } else {
            emit(GetAllServicesErrorState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get All Services is $error');
          emit(GetAllServicesErrorState(error: error.toString()));
        });
  }

 Future<void> filterServices() async {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredServices = List.from(userServicesResponse.data ?? []);
    } else {
      filteredServices = (userServicesResponse.data ?? [])
          .where((service) {
            final name = (service.name ?? '').toLowerCase();
            return name.contains(query);
          })
          .toList();
    }

    emit(FilteredServicesState());
  }
  AnnouncementsResponseModel announcementsResponseModel = AnnouncementsResponseModel();
    Future<void> getAllAnnouncements() async {
    emit(GetAllAnnouncementsBannersLoadingState());
    await HomeService.getAllAnnouncements()
        .then((value) {
          announcementsResponseModel = value;
          AppLogger.success('getAllAnnouncements==> ${value.data}');
          AppLogger.success('getAllAnnouncements==> ${value.data?.length}');
          if (value.success == true) {
            emit(GetAllAnnouncementsBannersSuccessfullyState());
          } else {
            emit(GetAllAnnouncementsBannersErrorState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get All Services is $error');
          emit(GetAllAnnouncementsBannersErrorState(error: error.toString()));
        });
  }
}
