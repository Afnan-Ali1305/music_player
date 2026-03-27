import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/Database/local_storage.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(isDarkMode: LocalStorage.getTheme()));

  void setTheme(bool isDark) {
    state = state.copyWith(isDarkMode: isDark);
  }

  void changeTheme() async {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);

    await LocalStorage.setTheme(newValue);
  }
}

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}


