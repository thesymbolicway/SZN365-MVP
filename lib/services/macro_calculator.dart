class MacroCalculator {
  static double calculateTDEE({
    required double weightLb,
    required double heightCm,
    required int age,
    required String gender,
    required double activityLevel,
  }) {
    double weightKg = weightLb * 0.453592;
    double bmr;

    if (gender == 'male') {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }

    return bmr * activityLevel;
  }
}
