import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor:
    const Color(0xffF5F7FA),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff2563EB),
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff2563EB),
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme:
    InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}