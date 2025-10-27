import 'package:diyar_app/feature/notifications/model/general_notification_model.dart';
import 'package:diyar_app/feature/notifications/model/notification_response_model.dart';

abstract class NotificationState {}
class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationSuccess extends NotificationState {
}
class NotificationError extends NotificationState {
  final String? error;
  NotificationError({this.error});
}
class MakeAllNotificationLoadingState extends NotificationState {}
class MakeAllNotificationSuccessState extends NotificationState {}
class MakeAllNotificationErrorState extends NotificationState {
  final String? error;
  MakeAllNotificationErrorState({this.error});
}

class MakeAsReadNotificationLoading extends NotificationState {}
class MakeAsReadNotificationSuccess extends NotificationState {
  final GeneralNotificationModel? generalNotificationModel;
  MakeAsReadNotificationSuccess({this.generalNotificationModel});
}
class MakeAsReadNotificationError extends NotificationState {
  final String? error;
  MakeAsReadNotificationError({this.error});
}
class DeleteNotificationLoading extends NotificationState {}
class DeleteNotificationSuccess extends NotificationState {
  final GeneralNotificationModel? generalNotificationModel;
  DeleteNotificationSuccess({this.generalNotificationModel});
}
class DeleteNotificationError extends NotificationState {
  final String? error;
  DeleteNotificationError({this.error});
}
class NotificationLoadingMore extends NotificationState{}
class ClearNotificationState extends NotificationState {
  final NotificationData? notifications;
  ClearNotificationState({this.notifications});
}
class NotificationEmpty extends NotificationState{}