import 'dart:developer';
import 'package:diyar_app/feature/notifications/controller/notification_state.dart';
import 'package:diyar_app/feature/notifications/model/general_notification_model.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';
import 'package:diyar_app/feature/notifications/service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationController extends Cubit<NotificationState> {
  NotificationController() : super(NotificationInitial());

  static NotificationController get(BuildContext context) =>
      BlocProvider.of(context);

  // List<NotificationData> notifications = [];
  NotificationResponseModel? notifications;
  late NotificationsService notificationsService;
  GeneralNotificationModel generalNotificationModel =
      GeneralNotificationModel();

  bool _isInitialized = false;

  // Future<void> init({bool force = false}) async {
  //   if (_isInitialized && force == false) return;
  //   notificationsService = await NotificationsService.create();
  //   _isInitialized = true;
  // }

  Future<void> init({bool force = false}) async {
    if (_isInitialized && force == false) return;

    try {
      notificationsService = await NotificationsService.create();
      _isInitialized = true;
    } catch (e) {
      log('NotificationController init error: ${e.toString()}');
      emit(
        NotificationError(error: 'Authentication error. Please log in again.'),
      );
      rethrow;
    }
  }

  int currentPage = 1;
  bool hasMore = true;
  final int perPage = 15;
  Future<void> fetchAllNotifications({
    int page = 1,
    bool refresh = false,
  }) async {
    if (page == 1) {
      emit(NotificationLoading());
    }
    try {
      await init();
      final value = await notificationsService.getAllNotifications(
        page: page,
        perPage: perPage,
      );
      if (refresh || page == 1) {
        notifications = value;
      } else {
        if (notifications == null) {
          notifications = value;
        } else {
          notifications?.data?.notifications?.addAll(
            value.data?.notifications ?? [],
          );
        }
      }
      currentPage = page;
      log('currentPage is $currentPage');
      log(
        'notifications length is ${notifications?.data?.notifications?.length}',
      );
      hasMore = (value.data?.notifications?.length ?? 0) >= perPage;
      emit(NotificationSuccess());
    } catch (e) {
      log('Error while fetching notifications: ${e.toString()}');
      emit(NotificationError(error: e.toString()));
    }
  }
bool isLoadingMore = false;
Future<void> fetchMoreNotifications() async {
  if (!hasMore || isLoadingMore) return; // prevent overlapping
  isLoadingMore = true;

  try {
    final nextPage = currentPage + 1;

    final value = await notificationsService.getAllNotifications(
      page: nextPage,
      perPage: perPage,
    );

    final newNotifications = value.data?.notifications ?? [];

    // Add new items
    notifications?.data?.notifications?.addAll(newNotifications);

    // Update page + hasMore
    currentPage = nextPage;
    hasMore = newNotifications.length >= perPage;

    emit(NotificationSuccess());   // ✅ rebuild UI
  } catch (e) {
    log("Error loading more: $e");
    emit(NotificationError(error: e.toString()));
  } finally {
    isLoadingMore = false;
  }
}


  Future<void> markAsRead(int id) async {
    emit(MakeAsReadNotificationLoading());
    try {
      // await init();
      final value = await notificationsService.markNotificationAsRead(id);
      generalNotificationModel = value;
      await fetchAllNotifications();
      emit(MakeAsReadNotificationSuccess());
    } catch (e) {
      emit(MakeAsReadNotificationError(error: e.toString()));
      log('Error while marking notification as read: ${e.toString()}');
    }
  }

  Future<void> markAllAsRead() async {
    emit(MakeAllNotificationLoadingState());
    try {
      await notificationsService.makeAllNotificationAsRead();
      await fetchAllNotifications();
      emit(MakeAllNotificationSuccessState());
    } catch (e) {
      log('Error while marking all notifications as read: ${e.toString()}');
      emit(MakeAllNotificationErrorState(error: e.toString()));
    }
  }

  Future<void> deleteNotification(int id) async {
    emit(DeleteNotificationLoading());
    try {
      await init();
      final value = await notificationsService.deleteNotification(id);
      generalNotificationModel = value;
      await fetchAllNotifications();
      emit(DeleteNotificationSuccess());
    } catch (e) {
      emit(DeleteNotificationError(error: e.toString()));
      log('Error while deleting notification: ${e.toString()}');
    }
  }

  void clearNotifications() {
    emit(ClearNotificationState(notifications: null));
  }

  bool get allRead {
    if (notifications?.data?.notifications == null) return true;
    return notifications!.data!.notifications!.every((n) => n.isRead == true);
  }

  bool get anyUnread {
    if (notifications?.data?.notifications == null) return false;
    return notifications!.data!.notifications!.any((n) => n.isRead == false);
  }
}
