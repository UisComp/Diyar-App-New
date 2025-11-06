import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_request_model.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:diyar_app/feature/facility_booking/service/facility_booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/custom_logger.dart';

class FacilityBookingController extends Cubit<FacilityBookingState> {
  FacilityBookingController() : super(FacilityBookingInitial());

  static FacilityBookingController get(BuildContext context) =>
      BlocProvider.of<FacilityBookingController>(context);

  FacilityResponse facilityBookingResponseModel = FacilityResponse();

  List<int> selectedIds = [];
  Future<void> getAllFacilityBooking() async {
    emit(FacilityBookingLoadingState());

    try {
      final value = await FacilityBookingService.getAllFacilityBooking();
      facilityBookingResponseModel = value;

      if (value.success == true) {
        AppLogger.success("Facility Booking fetched successfully");
        emit(FacilityBookingSuccessState());
      } else {
        emit(FacilityBookingFailureState(errorMessage: value.message));
      }
    } catch (e) {
      emit(FacilityBookingFailureState(errorMessage: e.toString()));
      AppLogger.error("getAllFacilityBooking: $e");
    }
  }

  void toggleItem(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    emit(FacilityBookingSelectionUpdated());
  }

  void toggleSelectAll() {
    if (areAllSelected) {
      selectedIds.clear();
    } else {
      selectedIds =
          facilityBookingResponseModel.data?.map((e) => e.id!).toList() ?? [];
    }
    emit(SelectAllFacilityBookingState());
  }

  bool get areAllSelected {
    final data = facilityBookingResponseModel.data ?? [];
    return selectedIds.length == data.length;
  }

  bool isItemSelected(int id) => selectedIds.contains(id);

  CreateRequestFacilityResponseModel createRequestFacilityResponseModel =
      CreateRequestFacilityResponseModel();

  Future<void> createFacilityRequest() async {
    if (!validateSelection()) return;
    emit(CreateFacilityRequestLoadingState());
    try {
      final value = await FacilityBookingService.createFacilityRequest(
        createRequestFacilityRequestModel: CreateRequestFacilityRequestModel(
          facilityIds: selectedIds,
        ),
      );
      createRequestFacilityResponseModel = value;
      if (value.success == true) {
        emit(CreateFacilityRequestSuccessState());
      } else {
        emit(CreateFacilityRequestFailureState(errorMessage: value.message));
      }
    } catch (e) {
      emit(CreateFacilityRequestFailureState(errorMessage: e.toString()));
      AppLogger.error("createFacilityRequest: $e");
    }
  }

  bool validateSelection() {
    if (selectedIds.isEmpty) {
      emit(PleaseSelectYourFacilityState());
      return false;
    }
    return true;
  }
}
