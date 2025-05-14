import 'package:flutter/material.dart';
import 'package:szn365/utils/colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.black,
      primaryColor: AppColors.limeGreen,
      brightness: Brightness.dark,
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white,),
      fontFamily: 'Poppins',
      textTheme:  TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          color: AppColors.white,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          //    color: AppColors.grayText,
          color: AppColors.white,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          //    color: AppColors.grayText,
          color: AppColors.white,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          //color: AppColors.grayText,
          color: AppColors.white.withOpacity(0.7),
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.limeGreen,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.white,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.limeGreen,
        unselectedItemColor: AppColors.grayText,
        selectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.limeGreen,
          foregroundColor: AppColors.black,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
