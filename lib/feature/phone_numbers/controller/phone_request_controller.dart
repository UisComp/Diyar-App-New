import 'dart:async';

import 'package:diyar_app/core/api/api_error_codes.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_request_state.dart';
import 'package:diyar_app/feature/phone_numbers/model/phone_numbers_models.dart';
import 'package:diyar_app/feature/phone_numbers/service/phone_numbers_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// Adds a number, or replaces [replacedPhoneId] with a new one: a code is
/// texted to the new number first, then the request goes to staff.
class PhoneRequestController extends Cubit<PhoneRequestState> {
  PhoneRequestController({this.replacedPhoneId})
    : super(PhoneRequestInitialState());

  static PhoneRequestController get(BuildContext context) =>
      BlocProvider.of(context);

  static const codeLength = 6;

  /// Null to add a number.
  final int? replacedPhoneId;

  PhoneChangeType get type =>
      replacedPhoneId == null ? PhoneChangeType.add : PhoneChangeType.replace;

  final phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
  );
  final codeController = TextEditingController();

  /// The number the code was sent to. Editing the number starts over.
  String? codeSentTo;

  Timer? _timer;
  int _resendIn = 0;
  int get resendIn => _resendIn;

  bool get _busy =>
      state is PhoneRequestSendingCodeState ||
      state is PhoneRequestSubmittingState;

  String get newPhone => phoneController.value.international;

  Future<void> sendCode() async {
    if (_busy) return;
    final phone = newPhone;
    emit(PhoneRequestSendingCodeState());
    final result = await PhoneNumbersService.sendCode(phone: phone);
    if (isClosed) return;
    if (result.success) {
      codeSentTo = phone;
      codeController.clear();
      _startCountdown(result.data!.resendIn);
      emit(PhoneRequestCodeSentState());
    } else {
      if (result.retryAfter != null) _startCountdown(result.retryAfter!);
      emit(PhoneRequestFailureState(result));
    }
  }

  Future<void> submit() async {
    final phone = codeSentTo;
    final code = codeController.text.trim();
    if (_busy || phone == null || code.length != codeLength) return;
    emit(PhoneRequestSubmittingState());
    final result = await PhoneNumbersService.createRequest(
      type: type,
      phone: phone,
      phoneId: replacedPhoneId,
      code: code,
    );
    if (isClosed) return;
    if (result.success) {
      _timer?.cancel();
      emit(PhoneRequestSubmittedState());
      return;
    }
    if (result.errorCode == ApiErrorCodes.invalid ||
        ApiErrorCodes.isDeadCode(result.errorCode)) {
      codeController.clear();
    }
    if (ApiErrorCodes.isDeadCode(result.errorCode)) {
      _timer?.cancel();
      _resendIn = 0;
    }
    emit(PhoneRequestFailureState(result));
  }

  /// Back to the number step (e.g. a typo in the number).
  void changeNumber() {
    _timer?.cancel();
    _resendIn = 0;
    codeSentTo = null;
    codeController.clear();
    emit(PhoneRequestInitialState());
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    _resendIn = seconds < 0 ? 0 : seconds;
    if (_resendIn == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      _resendIn = _resendIn > 0 ? _resendIn - 1 : 0;
      if (_resendIn == 0) timer.cancel();
      emit(PhoneRequestTickState(_resendIn));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    phoneController.dispose();
    codeController.dispose();
    return super.close();
  }
}
