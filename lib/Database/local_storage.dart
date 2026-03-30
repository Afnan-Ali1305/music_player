import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/models/.playlist.dart';

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

  static Uint8List? getProfileImage() {
    return box.get('profile_image');
  }

  static Future<void> setProfileImage(Uint8List imageBytes) async {
    await box.put('profile_image', imageBytes);
  }

  static Future<void> deleteProfileImage() async {
    await box.delete('profile_image');
  }

  static Future<void> setFavouriteMap(Map<int, bool> favMap) async {
    // Hive can’t store Map<int,bool> directly; convert keys to String
    final stringMap = favMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await box.put('favourite_map', stringMap);
  }

  // Get favourite map
  static Map<int, bool> getFavouriteMap() {
    final raw = box.get('favourite_map', defaultValue: <String, bool>{});
    return (raw as Map).map(
      (key, value) => MapEntry(int.parse(key), value as bool),
    );
  }

  static Future<void> savePlaylists(List<Playlist> playlists) async {
    final listMap = playlists.map((p) => p.toMap()).toList();
    await box.put('user_playlists', listMap);
  }

  static List<Playlist> getPlaylists() {
    final rawList = box.get('user_playlists', defaultValue: <dynamic>[]);

    if (rawList is! List) {
      return []; // safety
    }

    return rawList.map((item) {
      // Safely convert _Map<dynamic, dynamic> → Map<String, dynamic>
      final map = Map<String, dynamic>.from(item as Map);
      return Playlist.fromMap(map);
    }).toList();
  }
}
