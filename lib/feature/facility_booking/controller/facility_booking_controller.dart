import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_request_model.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_response_model.dart';
import 'package:diyar_app/feature/facility_booking/model/facility_booking_history_response_model.dart';
import 'package:diyar_app/feature/facility_booking/service/facility_booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/custom_logger.dart';

class FacilityBookingController extends Cubit<FacilityBookingState> {
  FacilityBookingController() : super(FacilityBookingInitial());

  static FacilityBookingController get(BuildContext context) =>
      BlocProvider.of<FacilityBookingController>(context);

  FacilityResponse facilityBookingResponseModel = FacilityResponse();
  FacilityBookingHistoryResponseModel facilityBookingHistoryResponseModel =
      FacilityBookingHistoryResponseModel();

  final Set<int> selectedIds = {};
  final Map<int, TextEditingController> notesControllers = {};
  final Map<int, DateTime> facilityDates = {};

  void _safeEmit(FacilityBookingState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void clearControllers() {
    for (var c in notesControllers.values) {
      c.dispose();
    }
    notesControllers.clear();
    facilityDates.clear();
    selectedIds.clear();
  }

  Future<void> getAllFacilityBooking() async {
    _safeEmit(FacilityBookingLoadingState());

    try {
      final value = await FacilityBookingService.getAllFacilityBooking();
      facilityBookingResponseModel = value;

      if (value.success == true) {
        AppLogger.success("Facility Booking fetched successfully");
        _safeEmit(FacilityBookingSuccessState());
      } else {
        _safeEmit(FacilityBookingFailureState(errorMessage: value.message));
      }
    } catch (e) {
      _safeEmit(FacilityBookingFailureState(errorMessage: e.toString()));
      AppLogger.error("getAllFacilityBooking: $e");
    }
  }

  void toggleItem(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    _safeEmit(FacilityBookingSelectionUpdated());
  }

  bool isItemSelected(int id) => selectedIds.contains(id);

  TextEditingController getNotesController(int id) {
    notesControllers.putIfAbsent(id, () => TextEditingController());
    return notesControllers[id]!;
  }

  void setFacilityDate(int id, DateTime date) {
    facilityDates[id] = date;
    _safeEmit(FacilityBookingRefreshState());
  }

  DateTime? getSelectedDate(int id) {
    return facilityDates[id];
  }

  List<FacilityItem> getSelectedFacilityItems() {
    return selectedIds
        .map(
          (id) => FacilityItem(
            id: id,
            notes: notesControllers[id]?.text.trim(),
            bookingDate: _formatDateTimeToUTC(facilityDates[id]),
          ),
        )
        .toList();
  }

  String? _formatDateTimeToUTC(DateTime? dateTime) {
    if (dateTime == null) return null;
    
    final utcDateTime = dateTime.toUtc();
    
    String year = utcDateTime.year.toString();
    String month = utcDateTime.month.toString().padLeft(2, '0');
    String day = utcDateTime.day.toString().padLeft(2, '0');
    String hour = utcDateTime.hour.toString().padLeft(2, '0');
    String minute = utcDateTime.minute.toString().padLeft(2, '0');
    String second = utcDateTime.second.toString().padLeft(2, '0');
    
    return '$year-$month-$day $hour:$minute:$second';
  }

  CreateRequestFacilityResponseModel createRequestFacilityResponseModel =
      CreateRequestFacilityResponseModel();

  Future<void> createFacilityRequest() async {
    if (!validateSelection()) return;
    
    _safeEmit(CreateFacilityRequestLoadingState());
    
    try {
      final req = CreateRequestFacilityRequestModel(
        facilities: getSelectedFacilityItems(),
      );
      
      AppLogger.log('Request Facility is ${req.toJson()}');
      
      final value = await FacilityBookingService.createFacilityRequest(
        createRequestFacilityRequestModel: req,
      );
      
      createRequestFacilityResponseModel = value;
      
      if (value.success == true) {
        _safeEmit(CreateFacilityRequestSuccessState());
      } else {
        _safeEmit(CreateFacilityRequestFailureState(errorMessage: value.message));
      }
    } catch (e) {
      _safeEmit(CreateFacilityRequestFailureState(errorMessage: e.toString()));
      AppLogger.error("createFacilityRequest: $e");
    }
  }

  bool validateSelection() {
    if (selectedIds.isEmpty) {
      _safeEmit(PleaseSelectYourFacilityState());
      return false;
    }
    return true;
  }

  Future<void> getFacilityBookingHistory() async {
    _safeEmit(FacilityBookingHistoryLoadingState());
    
    try {
      final value = await FacilityBookingService.getFacilityBookingHistory();
      facilityBookingHistoryResponseModel = value;
      
      if (value.success == true) {
        _safeEmit(FacilityBookingHistorySuccessState());
      } else {
        _safeEmit(FacilityBookingHistoryFailureState(errorMessage: value.message));
      }
    } catch (e) {
      _safeEmit(FacilityBookingHistoryFailureState(errorMessage: e.toString()));
      AppLogger.error("getFacilityBookingHistory: $e");
    }
  }
}