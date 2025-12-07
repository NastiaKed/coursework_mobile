import 'package:flutter/material.dart';

class AppColors {
  static const background = Colors.white;
  static const text = Colors.black;
  static const primary = Colors.black;
  static const inputBorder = Colors.black;
  static const buttonText = Colors.white;
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Poppins',

  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.text,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: AppColors.text,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.buttonText,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
  ),

  // TextField — білі з чорним бордером
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(
      color: AppColors.text.withOpacity(0.4),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.inputBorder,
        width: 1.3,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.inputBorder,
        width: 1.6,
      ),
    ),
  ),

  // Bottom Navigation Bar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.background,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.text,
    elevation: 0,
  ),
);
