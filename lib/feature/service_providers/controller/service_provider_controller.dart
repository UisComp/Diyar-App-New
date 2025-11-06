import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/service_providers/controller/service_provider_state.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_response.dart';
import 'package:diyar_app/feature/service_providers/service/service_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceProviderController extends Cubit<ServiceProviderState> {
  ServiceProviderController() : super(ServiceProviderInitial());
  static ServiceProviderController get(BuildContext context) =>
      BlocProvider.of(context);

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
}
