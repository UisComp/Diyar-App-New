import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/home/model/user_services_model.dart';
import 'package:diyar_app/feature/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(HomeInitial());
  static HomeController get(BuildContext context) => BlocProvider.of(context);
  final TextEditingController searchController = TextEditingController();

  AppTab currentTab = AppTab.home;

  void changeTab(AppTab tab) {
    currentTab = tab;
    emit(ChangeIndexBottomNavBarState());
  }

  /// Service types surfaced on the home grid. News (type 1) is shown as the
  /// standalone "Project Timeline" banner instead.
  static const _homeServiceTypes = {5, 8, 10};

  // Sections start as loading so the first frame shows skeletons rather than
  // flashing an empty state before the first request goes out.
  bool isServicesLoading = true;
  bool servicesFailed = false;
  bool isAnnouncementsLoading = true;
  bool announcementsFailed = false;

  /// Loads every home section in parallel.
  Future<void> loadHome() =>
      Future.wait([getAllServices(), getAllAnnouncements()]);

  UserServicesResponse userServicesResponse = UserServicesResponse();
  List<UserServiceData> filteredServices = [];

  /// Active home services matching the current search query.
  List<UserServiceData> get homeServices {
    final query = searchController.text.trim().toLowerCase();
    return (userServicesResponse.data ?? [])
        .where(
          (service) =>
              service.isActive == true &&
              _homeServiceTypes.contains(service.type) &&
              (query.isEmpty ||
                  (service.name ?? '').toLowerCase().contains(query) ||
                  (service.nameAr ?? '').toLowerCase().contains(query)),
        )
        .toList();
  }

  Future<void> getAllServices() async {
    isServicesLoading = true;
    servicesFailed = false;
    emit(GetAllServicesLoadingState());
    await HomeService.getAllServices()
        .then((value) {
          userServicesResponse = value;
          isServicesLoading = false;
          AppLogger.success('getAllServices==> ${value.data?.length}');
          if (value.success == true) {
            emit(GetAllServicesSuccessfullyState());
          } else {
            servicesFailed = true;
            emit(GetAllServicesErrorState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get All Services is $error');
          isServicesLoading = false;
          servicesFailed = true;
          emit(GetAllServicesErrorState(error: error.toString()));
        });
  }

  Future<void> filterServices() async {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredServices = List.from(userServicesResponse.data ?? []);
    } else {
      filteredServices = (userServicesResponse.data ?? []).where((service) {
        final name = (service.name ?? '').toLowerCase();
        return name.contains(query);
      }).toList();
    }

    emit(FilteredServicesState());
  }

  AnnouncementsResponseModel announcementsResponseModel =
      AnnouncementsResponseModel();
  Future<void> getAllAnnouncements() async {
    isAnnouncementsLoading = true;
    announcementsFailed = false;
    emit(GetAllAnnouncementsBannersLoadingState());
    await HomeService.getAllAnnouncements()
        .then((value) {
          announcementsResponseModel = value;
          isAnnouncementsLoading = false;
          AppLogger.success('getAllAnnouncements==> ${value.data?.length}');
          if (value.success == true) {
            emit(GetAllAnnouncementsBannersSuccessfullyState());
          } else {
            announcementsFailed = true;
            emit(GetAllAnnouncementsBannersErrorState(error: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error('Error Happen While Get All Announcements is $error');
          isAnnouncementsLoading = false;
          announcementsFailed = true;
          emit(GetAllAnnouncementsBannersErrorState(error: error.toString()));
        });
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
