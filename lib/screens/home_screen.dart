// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:music_player/extensions/extension_constant.dart';
// import 'package:music_player/router/app_router.gr.dart';

// @RoutePage()
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text("PlayMusic", style: context.textTheme.titleLarge),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: InkWell(
//                 onTap: () {
//                   context.router.push(const AppSettingsRoute());
//                 },
//                 child: Icon(Icons.settings, size: 25),
//               ),
//             ),
//           ],
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 250,
//                 width: double.infinity,
//                 child: Card(child: Placeholder()),
//               ),
//               TabBar(tabs: [],),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/music_tabs/albums_tab.dart';
import 'package:music_player/music_tabs/artisits_tab.dart';
import 'package:music_player/music_tabs/folders_tab.dart';
import 'package:music_player/music_tabs/songs_tab.dart';
import 'package:music_player/permissions/audio_permission.dart';
import 'package:music_player/router/app_router.gr.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List songs = [];
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initApp();
    });
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initApp() async {
    hasPermission = await AudioPermission.request();
    final OnAudioQuery audioQuery = OnAudioQuery();

    Future<List<SongModel>> loadSongs() async {
      return await audioQuery.querySongs();
    }

    if (hasPermission) {
      songs = await loadSongs(); // on_audio_query use karo
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "PlayMusic",
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search screen
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.router.push(const AppSettingsRoute());
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Recently Played Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recently Played",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text("See all")),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8, // Replace with actual recent songs count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[800],
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/placeholder_album.jpg',
                                    ), // Use real album art later
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    size: 50,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Song Title ${index + 1}",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Artist Name",
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Library Tabs
          TabBar(
            controller: _tabController,
            labelStyle: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: textTheme.titleSmall,
            tabs: const [
              Tab(text: "Songs"),
              Tab(text: "Albums"),
              Tab(text: "Artists"),
              Tab(text: "Folders"),
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.start,
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Songs Tab
                SongsTab(allSongs: songs),

                // Albums Tab (Placeholder)
                AlbumsTab(),
                ArtisitsTab(),
                FoldersTab(),
              ],
            ),
          ),
        ],
      ),

      // Mini Player at Bottom (Always visible when something is playing)
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            top: BorderSide(color: Colors.grey.shade800, width: 0.5),
          ),
        ),
        child: ListTile(
          dense: true,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.album, color: Colors.white70),
          ),
          title: const Text(
            "Now Playing - Song Title",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text(
            "Artist Name",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow, size: 32),
                onPressed: () {},
              ),
              IconButton(icon: const Icon(Icons.skip_next), onPressed: () {}),
            ],
          ),
          onTap: () {
            // Navigate to full player screen
          },
        ),
      ),
    );
  }
}
