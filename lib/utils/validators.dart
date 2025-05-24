class AppValidators {

  static String? Function(String?) getValidator({
    required String errorText,
  }) {
    return (val) {
      if (val == null || val.trim().isEmpty) return errorText;

      final numValue = double.tryParse(val);
      if (numValue == null || numValue <= 0) return errorText;

      return null;
    };
  }

  static String? Function(String?) getAgeValidator({
    required String errorText,
    int minAge = 13,
    int maxAge = 80,
  }) {
    return (val) {
      if (val == null || val.trim().isEmpty) return errorText;

      final numValue = int.tryParse(val);
      if (numValue == null) return errorText;

      if (numValue < minAge || numValue > maxAge) {
        return 'Age must be between $minAge and $maxAge';
      }

      return null;
    };
  }

  static String? Function(String?) getWeightValidator({
    required String errorText,
    double minWeight = 50.0,
    double maxWeight = 700.0,
  }) {
    return (val) {
      if (val == null || val.trim().isEmpty) return errorText;

      final numValue = double.tryParse(val);
      if (numValue == null) return errorText;

      if (numValue < minWeight || numValue > maxWeight) {
        return 'Weight must be between ${minWeight.toInt()} and ${maxWeight.toInt()} lbs';
      }

      return null;
    };
  }

  static String? Function(String?) getHeightValidatorInCm({
    required String errorText,
    double minHeight = 120.0,
    double maxHeight = 250.0,
  }) {
    return (val) {
      if (val == null || val.trim().isEmpty) return errorText;

      final numValue = double.tryParse(val);
      if (numValue == null) return errorText;

      if (numValue < minHeight || numValue > maxHeight) {
        return 'Height must be between ${minHeight.toInt()} cm and ${maxHeight.toInt()} cm';
      }

      return null;
    };
  }



}
