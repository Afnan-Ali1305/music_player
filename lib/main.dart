import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/features/settings/providers/theme_provider.dart';
import 'package:music_player/core/router/app_router.dart';
import 'package:music_player/data/services/audio_player_services.dart';
import 'package:music_player/core/theme/app_theme.dart';

late AudioHandler globalAudioHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Musify');
  globalAudioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.music_player.audio',
      androidNotificationChannelName: 'Musify Playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      androidNotificationChannelDescription: 'Musify music playback controls',
    ),
  );
  runApp(ProviderScope(child: MyApp()));
}

AppRouter appRoute = AppRouter();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeState.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      routerConfig: appRoute.config(),
    );
  }
}