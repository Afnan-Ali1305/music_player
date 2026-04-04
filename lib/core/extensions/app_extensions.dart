import 'package:flutter/material.dart';

extension BuildContextHelpers on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}




// Database folder => local_storage.dart
// Extension floder => extension_consantant.dart
// models floder => playlist.dart , song.dart
// music_tabs floder => songs_tab.dart, playlist_tab.dart , favourites_songs_tab.dart , albums_tab.dart
// permission  floder=> audio_permission.dart
// providers  floder=> songs_providers.dart , theme_provider.dart , user_provider.dart 
// router  floder=> app_router.dart ,, app_router.gr.dart 
// screens  floder=> app_settings.dart, home_screen.dart , pick_image_screen.dart, player_screen.dart, splash_screenk.dart , user_name_screen.dart 
// services floder => audio_player_services.dart 
// theme floder = > app_colors.dart , app_theme.dart 
// widgets  floder=> edit_user_name.dart , image_picker.dart , privacy_policy.dart , settings_row.dart 
// main.dart 