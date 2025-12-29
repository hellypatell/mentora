import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _key = 'isDarkMode';
  static const String _boxName = 'settingsBox';

  ThemeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() async {
    var box = await Hive.openBox(_boxName);
    bool isDark = box.get(_key, defaultValue: true);
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    var box = await Hive.openBox(_boxName);
    bool isDark = value == ThemeMode.dark;
    value = isDark ? ThemeMode.light : ThemeMode.dark;
    box.put(_key, !isDark);
  }
}

// ✅ Make the global instance available to all files
final themeNotifier = ThemeNotifier();
