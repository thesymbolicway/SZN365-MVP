
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFB6D434);
  static const secondary = Color(0xFFCDDC39);    // Lime
  static const background = Color(0xFFF5F5F5);    // Light Gray
  static const accent = Color(0xFFFF5722);       // Deep Orange
  static const text = Color(0xFF212121);       // Dark Text
  static const textLight = Color(0x8A000000);       // Dark Text
  static const grey = Colors.grey;
  static const redAccent = Colors.redAccent;

  static const Color limeGreen = Color(0xFFA8E222); // A8E222_1
  static const Color buttonGradient = Color(0xFFFDD701);

  static const Color white = Color(0xFFFFFFFF);     // FFFFFF_1
  static const Color black = Color(0xFF000000);     // 000000_1
  static const Color darkBackground = Color(0xFF1C2526); // 1C2526_1
  static const Color grayText = Color(0xFF4A4A4A);   // 4A4A4A_1

  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.black,
      AppColors.darkBackground,
    ],
  );
}
