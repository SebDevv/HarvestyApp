import 'package:flutter/material.dart';

class AppTheme {
  // ===== LIGHT THEME =====
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Color(0xFF6C63FF),
      background: Color(0xFFF8F9FB),
      surface: Colors.white,
    ),

    scaffoldBackgroundColor: Color(0xFFF8F9FB),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // ===== DARK THEME =====
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xFF6C63FF),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
    ),

    scaffoldBackgroundColor: Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
  );
}
