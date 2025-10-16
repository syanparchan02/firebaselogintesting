class FriedChicken {
  int chicken;
  String flavor;
  int oil;
  int salt;
  FriedChicken({
    required this.chicken,
    required this.flavor,
    required this.oil,
    required this.salt,
  });
  Map<String, dynamic> toFirebaseMap() {
    return {'chicken': chicken, 'flavor': flavor, 'oil': oil, 'salt': salt};
  }
}
