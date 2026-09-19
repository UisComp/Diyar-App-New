import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/finance/controller/finance_refresh_notifier.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/service/finance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinanceController extends Cubit<FinanceState> {
  FinanceController() : super(const FinanceInitialState()) {
    FinanceRefreshNotifier.instance.addListener(_onRefreshRequested);
  }

  static FinanceController get(BuildContext context) =>
      BlocProvider.of<FinanceController>(context);

  FinanceResponseModel financeResponseModel = const FinanceResponseModel();

  FinancialData? get data => financeResponseModel.data;
  bool get hasData => data != null;

  bool _isFetching = false;
  int _revision = 0;

  /// Fetches `/user/finance`. With [silent], keeps the current content on
  /// screen (no loading state), used for background refreshes.
  Future<void> getFinance({bool silent = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    if (!silent || !hasData) emit(const GetFinanceLoadingState());
    try {
      final response = await FinanceService.getFinance();
      if (isClosed) return;
      if (response.success == true) {
        financeResponseModel = response;
        emit(GetFinanceSuccessState(++_revision));
      } else {
        AppLogger.error("Error While Get Finance: ${response.message}");
        emit(GetFinanceFailureState(errorMessage: response.message));
      }
    } catch (e) {
      AppLogger.error("Error While Get Finance: $e");
      if (!isClosed) emit(GetFinanceFailureState(errorMessage: e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  void _onRefreshRequested() => getFinance(silent: true);

  @override
  Future<void> close() {
    FinanceRefreshNotifier.instance.removeListener(_onRefreshRequested);
    return super.close();
  }
}
