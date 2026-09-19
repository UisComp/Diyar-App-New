import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_numbers_state.dart';
import 'package:diyar_app/feature/phone_numbers/model/phone_numbers_models.dart';
import 'package:diyar_app/feature/phone_numbers/service/phone_numbers_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The resident's numbers and their change requests.
class PhoneNumbersController extends Cubit<PhoneNumbersState> {
  PhoneNumbersController() : super(PhoneNumbersInitialState());

  static PhoneNumbersController get(BuildContext context) =>
      BlocProvider.of(context);

  PhoneNumbersOverview overview = const PhoneNumbersOverview();

  /// True until the first load settles.
  bool get isFirstLoad => !_loadedOnce;
  bool _loadedOnce = false;

  bool get _busy =>
      state is PhoneNumbersLoadingState ||
      state is PhoneNumbersActionLoadingState;

  Future<void> load() async {
    if (state is PhoneNumbersLoadingState) return;
    emit(PhoneNumbersLoadingState());
    final result = await PhoneNumbersService.getPhones();
    if (isClosed) return;
    if (result.success) {
      overview = result.data!;
      _loadedOnce = true;
      emit(PhoneNumbersLoadedState());
    } else {
      emit(PhoneNumbersLoadFailureState(result));
    }
  }

  /// Immediate: no approval needed.
  Future<void> makePrimary(int phoneId) async {
    if (_busy) return;
    emit(PhoneNumbersActionLoadingState());
    final result = await PhoneNumbersService.makePrimary(phoneId);
    if (isClosed) return;
    if (result.success) {
      overview = result.data!;
      emit(PhoneNumbersActionSuccessState(PhoneNumbersAction.madePrimary));
    } else {
      emit(PhoneNumbersActionFailureState(result));
    }
  }

  /// Asks staff to remove the number. No code needed.
  Future<void> requestRemoval(int phoneId) => _requestThenReload(
    () => PhoneNumbersService.createRequest(
      type: PhoneChangeType.remove,
      phoneId: phoneId,
    ),
    PhoneNumbersAction.removalRequested,
  );

  Future<void> cancelRequest(int requestId) => _requestThenReload(
    () => PhoneNumbersService.cancelRequest(requestId),
    PhoneNumbersAction.requestCancelled,
  );

  Future<void> _requestThenReload(
    Future<ApiResult<dynamic>> Function() send,
    PhoneNumbersAction action,
  ) async {
    if (_busy) return;
    emit(PhoneNumbersActionLoadingState());
    final result = await send();
    if (isClosed) return;
    if (!result.success) {
      emit(PhoneNumbersActionFailureState(result));
      return;
    }
    emit(PhoneNumbersActionSuccessState(action));
    await load();
  }
}
