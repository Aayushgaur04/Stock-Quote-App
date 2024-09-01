import 'package:flutter/material.dart';
import 'colors.dart';

class DarkTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: DarkColors.primaryColor,
      hintColor: DarkColors.accentColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: DarkColors.accentColor, // Gold color for headings
          fontSize: 72,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway'
        ),
        bodyLarge: TextStyle(color: DarkColors.textColor, fontFamily: 'Raleway'),
        bodyMedium: TextStyle(color: DarkColors.textColor, fontFamily: 'Raleway'),
      ),

      buttonTheme: const ButtonThemeData(
        buttonColor: DarkColors.primaryColor,
      ),
      colorScheme: const ColorScheme(
          primary: DarkColors.primaryColor,
          secondary: DarkColors.accentColor,
          surface: DarkColors.primaryColor,
          error: Colors.red,
          onPrimary: DarkColors.textColor,
          onSecondary: DarkColors.textColor,
          onSurface: DarkColors.textColor,
          onError: DarkColors.textColor,
          brightness: Brightness.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.primaryColor,
        selectedItemColor: DarkColors.accentColor,
        unselectedItemColor: DarkColors.textColor.withOpacity(0.7),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: DarkColors.textColor),
        unselectedLabelStyle: TextStyle(color: DarkColors.textColor.withOpacity(0.7)),
      )
      // Add additional theme configurations as needed
    );
  }
}

