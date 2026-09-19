sealed class FinanceState {
  const FinanceState();
}

class FinanceInitialState extends FinanceState {
  const FinanceInitialState();
}

class GetFinanceLoadingState extends FinanceState {
  const GetFinanceLoadingState();
}

/// Carries a [revision] so two successive fetches are never equal states.
/// Bloc drops an `emit` whose state equals the current one, and a const marker
/// state is canonicalised to a single instance — which would make a silent
/// refresh (no loading state in between) emit `Success` over `Success` and
/// rebuild nothing.
class GetFinanceSuccessState extends FinanceState {
  final int revision;
  const GetFinanceSuccessState(this.revision);
}

class GetFinanceFailureState extends FinanceState {
  final String? errorMessage;
  const GetFinanceFailureState({this.errorMessage});
}
