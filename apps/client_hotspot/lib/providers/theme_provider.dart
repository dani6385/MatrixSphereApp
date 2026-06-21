import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Default theme is to follow the system settings
  ThemeMode _themeMode = ThemeMode.system;

  // Getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Check if the current effective theme is dark.
  // This considers ThemeMode.system and the platform brightness.
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Setter to change the theme mode and notify listeners
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
