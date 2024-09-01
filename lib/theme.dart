import 'package:flutter/material.dart';
import 'colors.dart';

class DarkTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: DarkColors.primaryColor,
      hintColor: DarkColors.accentColor,
      fontFamily: 'Raleway', // Setting fontFamily globally instead of repeating in each TextStyle

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: DarkColors.accentColor, // Gold color for headings
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: DarkColors.textColor),
        bodyMedium: TextStyle(color: DarkColors.textColor),
      ),

      buttonTheme: const ButtonThemeData(
        buttonColor: DarkColors.primaryColor,
        textTheme: ButtonTextTheme.primary, // Ensures proper button text color
      ),

      colorScheme: const ColorScheme.dark(
        primary: DarkColors.primaryColor,
        secondary: DarkColors.accentColor,
        surface: DarkColors.primaryColor,
        error: Colors.red,
        onPrimary: DarkColors.textColor,
        onSecondary: DarkColors.textColor,
        onSurface: DarkColors.textColor,
        onError: DarkColors.textColor,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.primaryColor,
        selectedItemColor: DarkColors.accentColor,
        unselectedItemColor: DarkColors.textColor.withOpacity(0.7),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: DarkColors.textColor),
        unselectedLabelStyle: TextStyle(color: DarkColors.textColor.withOpacity(0.7)),
      ),
    );
  }
}
