import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData lightTheme() => ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    surface: AppColors.lightCard,
  ),
  scaffoldBackgroundColor: AppColors.lightBg,
  cardColor: AppColors.lightCard,
  dividerColor: AppColors.lightBorder,
  inputDecorationTheme: _commonInputTheme(
    fillColor: Colors.white,
    borderColor: AppColors.lightBorder,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
  ),
);

ThemeData darkTheme() => ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.darkCard,
  ),
  scaffoldBackgroundColor: AppColors.darkBg,
  cardColor: AppColors.darkCard,
  dividerColor: AppColors.darkBorder,
  inputDecorationTheme: _commonInputTheme(
    fillColor: AppColors.darkCard,
    borderColor: AppColors.darkBorder,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
  ),
);


InputDecorationTheme _commonInputTheme({required Color fillColor, required Color borderColor}) {
  return InputDecorationTheme(
    filled: true,
    fillColor: fillColor,
    contentPadding: const .symmetric(horizontal: 16, vertical: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: .circular(12),
      borderSide: const BorderSide(width: 1.5, color: AppColors.primary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: .circular(12),
      borderSide: BorderSide(width: 1, color: borderColor),
    ),
    border: OutlineInputBorder(
      borderRadius: .circular(12),
    ),
  );
}