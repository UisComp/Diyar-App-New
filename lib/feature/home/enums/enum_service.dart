enum ServiceType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10,
  type11,
  type12,
  type13,
  type14;

  static ServiceType? fromInt(int? value) {
    if (value == null) return null;
    if (value < 1 || value > 14) return null;
    return ServiceType.values[value - 1];
  }

  int get number => index + 1;
}
