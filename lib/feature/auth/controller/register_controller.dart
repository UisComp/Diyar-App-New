import 'package:diyar_app/core/formatter/unit_code.dart';
import 'package:diyar_app/feature/auth/controller/register_state.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A unit code as the server stores it: trimmed, upper case and in its
/// shape's canonical form (` b1g1 ` → `B1-G-01`). A code of no known shape
/// is only trimmed and upper-cased, never rewritten.
String normalizeUnitCode(String code) => UnitCode.normalize(code);

/// One unit code on the registration form. Codes aren't checked while
/// typing: staff match or reject each one when they review the account.
class UnitCodeEntry {
  UnitCodeEntry();

  final TextEditingController controller = TextEditingController();

  /// The server's message for this code (`unit_codes.<index>`), until the
  /// code is edited.
  String? serverError;
  String _lastText = '';

  /// Trimmed and upper-cased, as the server stores it.
  String get code => normalizeUnitCode(controller.text);

  void _dispose() => controller.dispose();
}

/// The registration form, after the phone number was verified: name,
/// optional email, one or more unit codes and a password. No project: staff
/// match each unit when they approve the account.
class RegisterController extends Cubit<RegisterState> {
  RegisterController({required this.args}) : super(RegisterInitialState()) {
    addUnit();
    for (final (key, field) in [
      ('name', nameController),
      ('email', emailController),
      ('password', passwordController),
    ]) {
      field.addListener(() => fieldErrors.remove(key));
    }
  }

  static RegisterController get(BuildContext context) =>
      BlocProvider.of(context);

  /// Most units one registration can list.
  static const maxUnits = 10;

  /// Longest unit code the server accepts.
  static const maxCodeLength = 50;

  final RegisterDetailsArgs args;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();

  final List<UnitCodeEntry> units = [];

  /// The server's messages for `name`, `email` and `password`, until the
  /// field is edited.
  final Map<String, String> fieldErrors = {};

  /// Rows behind each code sent, in order: `unit_codes.<i>` is `_sent[i]`.
  List<UnitCodeEntry> _sent = [];

  /// The last failure put messages under fields.
  bool get hasInlineErrors =>
      fieldErrors.isNotEmpty || units.any((u) => u.serverError != null);

  bool get canAddUnit => units.length < maxUnits;

  /// The codes to send: non-empty, without duplicates, in the order typed.
  List<String> get unitCodes => [for (final unit in _rowsToSend()) unit.code];

  List<UnitCodeEntry> _rowsToSend() {
    final seen = <String>{};
    return [
      for (final unit in units)
        if (unit.code.isNotEmpty && seen.add(unit.code)) unit,
    ];
  }

  /// An earlier row already has this code (the first one is fine).
  bool isDuplicate(UnitCodeEntry entry) {
    if (entry.code.isEmpty) return false;
    final index = units.indexOf(entry);
    return units.take(index < 0 ? 0 : index).any((u) => u.code == entry.code);
  }

  void addUnit() {
    if (!canAddUnit) return;
    final entry = UnitCodeEntry();
    // Controller listeners also fire on cursor moves; only react to edits.
    entry.controller.addListener(() {
      final text = entry.controller.text;
      if (text == entry._lastText) return;
      entry._lastText = text;
      entry.serverError = null;
    });
    units.add(entry);
    if (units.length > 1) emit(RegisterUnitsChangedState());
  }

  void removeUnit(UnitCodeEntry entry) {
    if (units.length == 1 || !units.remove(entry)) return;
    entry._dispose();
    emit(RegisterUnitsChangedState());
  }

  /// [locale]: the language of the resident's SMS.
  Future<void> submit({required String locale}) async {
    final rows = _rowsToSend();
    if (state is RegisterLoadingState || rows.isEmpty) return;
    _sent = rows;
    final codes = [for (final row in rows) row.code];
    fieldErrors.clear();
    for (final unit in units) {
      unit.serverError = null;
    }
    emit(RegisterLoadingState());
    final email = emailController.text.trim();
    final result = await AuthService.register(
      registrationToken: args.registrationToken,
      name: nameController.text.trim(),
      email: email.isEmpty ? null : email,
      unitCodes: codes,
      password: passwordController.text,
      passwordConfirmation: confirmationController.text,
      locale: locale,
    );
    if (isClosed) return;
    if (!result.success) _placeFieldErrors(result.fieldErrors);
    emit(
      result.success ? RegisterSuccessState() : RegisterFailureState(result),
    );
  }

  /// Puts each 422 message under its field: `unit_codes.1` under the second
  /// code sent, `unit_codes` (too few / too many) under the first row.
  void _placeFieldErrors(Map<String, List<String>> errors) {
    errors.forEach((key, messages) {
      if (messages.isEmpty) return;
      final index = RegExp(r'^unit_codes\.(\d+)$').firstMatch(key)?.group(1);
      if (index != null) {
        final i = int.parse(index);
        if (i < _sent.length) _sent[i].serverError = messages.first;
      } else if (key == 'unit_codes') {
        units.first.serverError = messages.first;
      } else if (const {'name', 'email', 'password'}.contains(key)) {
        fieldErrors[key] = messages.first;
      }
    });
  }

  @override
  Future<void> close() {
    for (final unit in units) {
      unit._dispose();
    }
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    return super.close();
  }
}
