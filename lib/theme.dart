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
          fontSize: 42,
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

class LightTheme {
  static ThemeData get themeData {
    return ThemeData(
        primaryColor: LightColors.primaryColor,
        hintColor: LightColors.accentColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: LightColors.textColor),
          bodyMedium: TextStyle(color: LightColors.textColor),
          displayLarge: TextStyle(color: LightColors.textColor),
          displayMedium: TextStyle(color: LightColors.textColor),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: LightColors.primaryColor,
        ),
        colorScheme: const ColorScheme(
          primary: LightColors.primaryColor,
          secondary: LightColors.accentColor,
          surface: LightColors.primaryColor,
          error: Colors.red,
          onPrimary: LightColors.textColor,
          onSecondary: LightColors.textColor,
          onSurface: LightColors.textColor,
          onError: LightColors.textColor,
          brightness: Brightness.light,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: LightColors.primaryColor,
          selectedItemColor: LightColors.accentColor,
          unselectedItemColor: LightColors.textColor.withOpacity(0.7),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: LightColors.textColor),
          unselectedLabelStyle: TextStyle(color: LightColors.textColor.withOpacity(0.7)),
        )
      // Add additional theme configurations as needed
    );
  }
}