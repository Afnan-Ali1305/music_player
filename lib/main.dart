import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/router/app_router.dart';
import 'package:music_player/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');

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
