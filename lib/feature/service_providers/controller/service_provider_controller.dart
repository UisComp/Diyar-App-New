import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
import 'package:diyar_app/feature/service_providers/model/create_service_provider_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/request_service_provider_model.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_history_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_response.dart';
import 'package:diyar_app/feature/service_providers/service/service_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceProviderController extends Cubit<ServiceProviderState> {
  ServiceProviderController() : super(ServiceProviderInitial());

  static ServiceProviderController get(BuildContext context) =>
      BlocProvider.of(context);
  final Set<int> selectedIds = {};
  final Map<int, TextEditingController> descControllers = {};
  final Map<int, DateTime> serviceDates = {};

  void clearControllers() {
    for (var c in descControllers.values) {
      c.dispose();
    }
    descControllers.clear();
    serviceDates.clear();
  }

  void toggleService(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    emit(ServiceProviderRefreshState());
  }

  TextEditingController getDescController(int id) {
    descControllers.putIfAbsent(id, () => TextEditingController());
    return descControllers[id]!;
  }

  void setServiceDate(int id, DateTime date) {
    serviceDates[id] = date;
    emit(ServiceProviderRefreshState());
  }

  DateTime? getSelectedDate(int id) {
    return serviceDates[id];
  }

  ServiceProviderResponse serviceProviderResponse = ServiceProviderResponse();
  ServiceProviderHistoryResponseModel serviceProviderHistoryResponseModel =
      ServiceProviderHistoryResponseModel();

  Future<void> getServiceProviders() async {
    emit(ServiceProviderLoadingState());
    await ServiceProviderService.getAllServiceProvider()
        .then((value) {
          serviceProviderResponse = value;
          if (value.success == true) {
            emit(ServiceProviderSuccessState());
          } else {
            emit(ServiceProviderFailureState(errorMessage: value.message));
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While Get All Service Provider is $error',
          );
          emit(ServiceProviderFailureState(errorMessage: error.toString()));
        });
  }

  List<ServiceItem> getSelectedServiceItems() {
    return selectedIds
        .map(
          (id) => ServiceItem(
            id: id,
            title: descControllers[id]?.text.trim(),
            bookingDate: _formatDateTimeToUTC(serviceDates[id]),
          ),
        )
        .toList();
  }

  /// Convert DateTime to UTC format for API
  /// Format: "2024-12-01 10:00:00"
  String? _formatDateTimeToUTC(DateTime? dateTime) {
    if (dateTime == null) return null;

    // Convert local time to UTC
    final utcDateTime = dateTime.toUtc();

    String year = utcDateTime.year.toString();
    String month = utcDateTime.month.toString().padLeft(2, '0');
    String day = utcDateTime.day.toString().padLeft(2, '0');
    String hour = utcDateTime.hour.toString().padLeft(2, '0');
    String minute = utcDateTime.minute.toString().padLeft(2, '0');
    String second = utcDateTime.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }

  Future<void> getServiceProviderHistory() async {
    emit(ServiceProviderHistoryLoadingState());
    await ServiceProviderService.getServiceProviderHistory()
        .then((value) {
          serviceProviderHistoryResponseModel = value;
          if (value.success == true) {
            emit(ServiceProviderHistorySuccessState());
          } else {
            emit(
              ServiceProviderHistoryFailureState(errorMessage: value.message),
            );
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While Get All Service Provider is $error',
          );
          emit(
            ServiceProviderHistoryFailureState(errorMessage: error.toString()),
          );
        });
  }

  CreateServiceProviderResponseModel createServiceProviderResponseModel =
      CreateServiceProviderResponseModel();

  Future<void> createServiceProvider() async {
    emit(CreateServiceProviderLoadingState());

    final req = RequestServiceProviderModel(
      services: getSelectedServiceItems(),
    );

    AppLogger.log('Request Service Provider is ${req.toJson()}');

    await ServiceProviderService.createServiceProviderRequest(
          requestServiceProviderModel: req,
        )
        .then((value) {
          createServiceProviderResponseModel = value;

          if (value.success == true) {
            emit(CreateServiceProviderSuccessState());
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While Create Service Provider is $error',
          );
          emit(
            CreateServiceProviderFailureState(errorMessage: error.toString()),
          );
        });
  }
}
