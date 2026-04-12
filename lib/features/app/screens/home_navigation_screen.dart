import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/core/router/app_router.gr.dart';

@RoutePage()
class HomeNavigationScreen extends ConsumerWidget {
  const HomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SearchRoute(),
        LibraryRoute(),
        SettingsRoute(),
      ],

      // smooth animation
      transitionBuilder: (context, child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },

      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,

          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: const Color(0xff363636),
            type: BottomNavigationBarType.fixed,
            currentIndex: tabsRouter.activeIndex,

            onTap: (index) {
              tabsRouter.setActiveIndex(index); // ✅ smooth switch
            },

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: "Library",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
