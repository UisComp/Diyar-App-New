import 'package:diyar_app/feature/facility_booking/controller/facility_booking_state.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_request_model.dart';
import 'package:diyar_app/feature/facility_booking/model/create_request_facility_response_model.dart'
    show CreateRequestFacilityResponseModel;
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
  final Map<int, DateTime> facilityStartDates = {};
  final Map<int, DateTime> facilityEndDates = {};

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
    facilityStartDates.clear();
    facilityEndDates.clear();
    selectedIds.clear();
  }

  Future<void> getAllFacilityBooking() async {
    _safeEmit(FacilityBookingLoadingState());

    try {
      final value = await FacilityBookingService.getAllFacilityBooking();
      facilityBookingResponseModel = value;

      if (value.success == true) {
        AppLogger.success("Facility Booking fetched successfully");
        _dropClosedSelections();
        _safeEmit(FacilityBookingSuccessState());
      } else {
        _safeEmit(FacilityBookingFailureState(errorMessage: value.message));
      }
    } catch (e) {
      _safeEmit(FacilityBookingFailureState(errorMessage: e.toString()));
      AppLogger.error("getAllFacilityBooking: $e");
    }
  }

  /// Every facility the last fetch listed.
  List<Facility> get facilities =>
      facilityBookingResponseModel.data ?? const <Facility>[];

  /// The listed facility with [id], or null once it's gone from the list.
  Facility? facilityById(int id) {
    for (final facility in facilities) {
      if (facility.id == id) return facility;
    }
    return null;
  }

  /// Whether [id] may be added to the request.
  bool canBook(int id) => facilityById(id)?.canBook ?? false;

  /// Whether anything in the list is taking bookings at all.
  bool get hasBookableFacilities =>
      facilities.any((facility) => facility.canBook);

  /// Adds or removes a facility. Deselecting always works; selecting is
  /// refused for a facility that isn't taking bookings, because the API
  /// creates the batch all-or-nothing — one closed facility would sink the
  /// whole request, and the resident would have picked a slot for nothing.
  void toggleItem(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      if (!canBook(id)) {
        _safeEmit(FacilityNotBookableState());
        return;
      }
      selectedIds.add(id);
    }
    _safeEmit(FacilityBookingSelectionUpdated());
  }

  /// Drops picks that stopped being bookable while the list was on screen,
  /// along with the slot chosen for them.
  void _dropClosedSelections() {
    final closed = selectedIds.where((id) => !canBook(id)).toList();
    for (final id in closed) {
      selectedIds.remove(id);
      facilityStartDates.remove(id);
      facilityEndDates.remove(id);
    }
  }

  /// Forgets the current picks and their details, after a request went
  /// through.
  void clearSelection() {
    selectedIds.clear();
    for (final c in notesControllers.values) {
      c.clear();
    }
    facilityStartDates.clear();
    facilityEndDates.clear();
  }

  bool isItemSelected(int id) => selectedIds.contains(id);

  TextEditingController getNotesController(int id) {
    notesControllers.putIfAbsent(id, () => TextEditingController());
    return notesControllers[id]!;
  }

  void setFacilityStartDate(int id, DateTime date) {
    facilityStartDates[id] = date;
    _safeEmit(FacilityBookingRefreshState());
  }

  void setFacilityEndDate(int id, DateTime date) {
    facilityEndDates[id] = date;
    _safeEmit(FacilityBookingRefreshState());
  }

  DateTime? getSelectedStartDate(int id) {
    return facilityStartDates[id];
  }

  DateTime? getSelectedEndDate(int id) {
    return facilityEndDates[id];
  }

  List<FacilityItem> getSelectedFacilityItems() {
    return selectedIds
        .map(
          (id) => FacilityItem(
            id: id,
            notes: notesControllers[id]?.text.trim(),
            bookingStart: _formatDateTimeToUTC(facilityStartDates[id]),
            bookingEnd: _formatDateTimeToUTC(facilityEndDates[id]),
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

    // Last check before sending: the list is a snapshot, and a facility the
    // resident picked may have closed its bookings since.
    if (selectedIds.any((id) => !canBook(id))) {
      _dropClosedSelections();
      _safeEmit(CreateFacilityRequestRejectedState());
      return getAllFacilityBooking();
    }

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
        clearSelection();
        _safeEmit(CreateFacilityRequestSuccessState());
      } else if (value.isRejected) {
        // Nothing in the batch was created. The usual cause is a facility
        // that closed its bookings after the list was fetched, so refresh it
        // rather than retrying with the stale one. The server's own message
        // is passed through: it also covers a slot clash.
        _safeEmit(
          CreateFacilityRequestRejectedState(errorMessage: value.message),
        );
        await getAllFacilityBooking();
      } else {
        _safeEmit(
          CreateFacilityRequestFailureState(errorMessage: value.message),
        );
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
        _safeEmit(
          FacilityBookingHistoryFailureState(errorMessage: value.message),
        );
      }
    } catch (e) {
      _safeEmit(FacilityBookingHistoryFailureState(errorMessage: e.toString()));
      AppLogger.error("getFacilityBookingHistory: $e");
    }
  }
}
