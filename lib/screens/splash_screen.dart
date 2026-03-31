import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:music_player/Database/local_storage.dart';
import 'package:music_player/providers/user_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/router/app_router.gr.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    // ⏱ Optional: small delay for animation
    await Future.delayed(const Duration(seconds: 1));

    // 🔹 Load theme from Hive
    final isDarkMode = LocalStorage.getTheme();
    ref.read(themeProvider.notifier).setTheme(isDarkMode);

    // 🔹 Check first-time login
    final user = ref.read(userProvider);
    if (user.isFirstTime) {
      // Go to username input
      if (context.mounted) {
        context.router.replace(const UserNameRoute());
      }
    } else {
      // Go to home
      context.router.replace(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     color: Theme.of(context).scaffoldBackgroundColor,
    //     child: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           // Your App Logo
    //           // Image.asset(
    //           //   "assets/logo/logo.png",
    //           //   width: double.infinity,
    //           //   height: double.infinity,
    //           // ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  return SizedBox.shrink();
  }
}
