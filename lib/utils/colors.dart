
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFB6D434);
  static const secondary = Color(0xFFCDDC39);
  static const background = Color(0xFFF5F5F5);
  static const accent = Color(0xFFFF5722);
  static const text = Color(0xFF212121);
  static const textLight = Color(0x8A000000);
  static const grey = Colors.grey;
  static const redAccent = Colors.redAccent;

  static const Color limeGreen = Color(0xFFA8E222);
  static const Color buttonGradient = Color(0xFFFDD701);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkBackground = Color(0xFF1C2526);
  static const Color grayText = Color(0xFF4A4A4A);

  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.black,
      AppColors.darkBackground,
    ],
  );

}
