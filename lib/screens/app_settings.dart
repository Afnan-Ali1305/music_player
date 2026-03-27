import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/theme_provider.dart';

@RoutePage()
class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    return Scaffold(
      body: Center(
        child: Switch(
          value: themeState.isDarkMode,
          onChanged: (value) {
            ref.read(themeProvider.notifier).changeTheme();
          },
        ),
      ),
    );
  }
}
