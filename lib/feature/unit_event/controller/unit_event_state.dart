abstract class UnitEventState {}

class UnitEventInitial extends UnitEventState {}
class GetUnitsByEventLoadingState extends UnitEventState {}
class GetUnitsByEventSuccessfullyState extends UnitEventState {}
class GetUnitsByEventErrorState extends UnitEventState {
  final String ?error;
  GetUnitsByEventErrorState({ this.error});
}