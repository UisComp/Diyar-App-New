import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
import 'package:diyar_app/feature/service_providers/model/create_service_provider_response_model.dart';
import 'package:diyar_app/feature/service_providers/model/request_service_provider_model.dart';
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
  void clearControllers() {
    for (var c in descControllers.values) {
      c.dispose();
    }
    descControllers.clear();
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

  List<ServiceItem> getSelectedServiceItems() {
    return selectedIds
        .map(
          (id) => ServiceItem(id: id, title: descControllers[id]?.text.trim()),
        )
        .toList();
  }

  ServiceProviderResponse serviceProviderResponse = ServiceProviderResponse();

  Future<void> getServiceProviders() async {
    emit(ServiceProviderLoadingState());
    await ServiceProviderService.getAllServiceProvider()
        .then((value) {
          serviceProviderResponse = value;
          if (value.success == true) {
            emit(ServiceProviderSuccessState());
          }
        })
        .catchError((error) {
          AppLogger.error(
            'Error Happen While Get All Service Provider is $error',
          );
          emit(ServiceProviderFailureState(errorMessage: error.toString()));
        });
  }

  CreateServiceProviderResponseModel createServiceProviderResponseModel =
      CreateServiceProviderResponseModel();

  Future<void> createServiceProvider() async {
    emit(CreateServiceProviderLoadingState());

    final req = RequestServiceProviderModel(
      services: getSelectedServiceItems(),
    );

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