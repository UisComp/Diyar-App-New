import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/model/general_response_model.dart';
import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/service/facility_booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FacilityBookingController extends Cubit<FacilityBookingState> {
  FacilityBookingController() : super(FacilityBookingInitial());
  static FacilityBookingController get(BuildContext context) =>
      BlocProvider.of<FacilityBookingController>(context);

  GeneralResponseModel facilityBookingResponseModel = GeneralResponseModel();
  Future<void> getAllFacilityBooking() async {
    emit(FacilityBookingLoadingState());
    // try {
    //   await FacilityBookingService.getAllFacilityBooking().then((value) {
    //     facilityBookingResponseModel = value;
    //     if (value.success == true) {
    //       AppLogger.success(
    //           "Facility Booking fetched successfully: ${value.data}");
    //       emit(FacilityBookingSuccessState());
    //     } else {
    //       emit(FacilityBookingFailureState(errorMessage: value.message));
    //     }
    //   });
    // } catch (e) {
    //   emit(FacilityBookingFailureState(errorMessage: e.toString()));
    //   AppLogger.error("Error in getAllFacilityBooking: $e");
    // }
  }
}
