abstract class UnitEventStates {}
class UnitEventInitial extends UnitEventStates {}
class GetUnitsByEventLoadingState extends UnitEventStates {}
class GetUnitsByEventSuccessfullyState extends UnitEventStates {}
class GetUnitsByEventErrorState extends UnitEventStates {
  final String ?error;
  GetUnitsByEventErrorState({ this.error});
}