import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static final box = Hive.box('appBox');

  static Future<void> setTheme(bool isDark) async {
    await box.put('isDarkMode', isDark);
  }

  static bool getTheme() {
    return box.get('isDarkMode', defaultValue: true);
  }

  static bool isFirstTime() {
    return box.get('hasVisited', defaultValue: true);
  }

  static Future<void> setVisited() async {
    await box.put('hasVisited', false);
  }

  // 🔹 Username
  static String? getUsername() {
    return box.get('username');
  }

  static Future<void> setUsername(String name) async {
    await box.put('username', name);
  }

  static Future<void> updateUsername(String name) async {
    await box.put('username', name);
  }
}
