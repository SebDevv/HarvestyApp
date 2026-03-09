import 'dart:async'; // for unawaited
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    // 1) Update UI immediately
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // 2) Persist without blocking the UI
    unawaited(_persist(isDark));
  }

  Future<void> _persist(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
