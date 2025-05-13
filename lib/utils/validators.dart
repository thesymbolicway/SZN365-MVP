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
}
