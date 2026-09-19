import 'package:flutter/foundation.dart';

/// Signals that financial data changed on the server (e.g. a `payment` or
/// `overdue` push arrived), so any visible finance screen refetches.
class FinanceRefreshNotifier extends ChangeNotifier {
  FinanceRefreshNotifier._();

  static final FinanceRefreshNotifier instance = FinanceRefreshNotifier._();

  void requestRefresh() => notifyListeners();
}
