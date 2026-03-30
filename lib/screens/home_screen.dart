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
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/music_tabs/favourite_songs_tab.dart';
import 'package:music_player/music_tabs/play_list_tab.dart';
import 'package:music_player/music_tabs/albums_tab.dart';
import 'package:music_player/music_tabs/songs_tab.dart';
import 'package:music_player/providers/songs_provider.dart';
import 'package:music_player/providers/user_provider.dart';
import 'package:music_player/router/app_router.gr.dart';
import 'package:on_audio_query/on_audio_query.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ✅ Properly typed lists
  // List<Song> songs = [];
  // List<Song> recentSongs = [];
  // bool hasPermission = false;
  // bool isLoading = true;

  // final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initApp();
      ref.read(songsProvider.notifier).fetchAllSongs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Properly load all songs with metadata
  // Future<void> initApp() async {
  //   hasPermission = await AudioPermission.request();

  //   if (hasPermission) {
  //     final loadedSongs = await _audioQuery.querySongs(
  //       sortType: SongSortType.DATE_ADDED,
  //       orderType: OrderType.DESC_OR_GREATER,
  //       uriType: UriType.EXTERNAL,
  //       ignoreCase: true,
  //     );

  //     setState(() {
  //       // ✅ Transform the list to store only specific data
  //       songs = loadedSongs
  //           .map(
  //             (s) => Song(
  //               songID: s.id,
  //               songName: s.title,
  //               songArtist: s.artist ?? "Unknown Artist",
  //               songPath: s.uri!,
  //             ),
  //           )
  //           .toList();

  //       recentSongs = songs.take(10).toList();
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(songsProvider);
    final textTheme = context.textTheme;
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          userState.userName ?? "PlayMusic",
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
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                child: userState.profilePicture != null
                    ? ClipOval(
                        child: Image.memory(
                          userState.profilePicture!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 25, color: Colors.grey),
              ),
              onTap: () {
                context.router.push(const AppSettingsRoute());
              },
            ),
          ),
        ],
      ),
      body: songState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !songState.hasPermission
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("Storage permission required"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(songsProvider.notifier).fetchAllSongs();
                    },
                    child: const Text("Grant Permission"),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // ✅ Recently Played Section with real song data
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
                          TextButton(
                            onPressed: () {},
                            child: const Text("See all"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: songState.recentSongs.isEmpty
                            ? const Center(child: Text("No songs found"))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: songState.recentSongs.length,
                                itemBuilder: (context, index) {
                                  final song = songState.recentSongs[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: SizedBox(
                                      width: 140,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ✅ Real album artwork
                                          QueryArtworkWidget(
                                            id: song.songID,
                                            type: ArtworkType.AUDIO,
                                            artworkHeight: 125,
                                            artworkWidth: 125,
                                            artworkFit:
                                                BoxFit.cover, // ⭐ important
                                            artworkBorder:
                                                BorderRadius.circular(12),
                                            nullArtworkWidget: Container(
                                              height: 125,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.music_note,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Gap(8),
                                          // ✅ Real song title
                                          Text(
                                            song.songName,
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // ✅ Real artist name
                                          Text(
                                            song.songArtist,
                                            style: textTheme.bodySmall
                                                ?.copyWith(color: Colors.grey),
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
                    Tab(text: "All Songs"),
                    Tab(text: "Favourites"),
                    Tab(text: "Playlist"),
                    Tab(text: "Albums"),
                  ],
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SongsTab(),
                      FavouriteSongsTab(),
                      PlaylistTab(),
                      AlbumsTab(),
                    ],
                  ),
                ),
              ],
            ),

      // Mini Player at Bottom
      bottomNavigationBar: songState.currentSong != null
          ? Container(
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade800, width: 0.5),
                ),
              ),
              child: ListTile(
                dense: true,
                leading: QueryArtworkWidget(
                  id: songState.currentSong!.songID,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                  artworkBorder: BorderRadius.circular(12),
                  artworkHeight: 50,
                  artworkWidth: 50,
                  nullArtworkWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white70),
                  ),
                ),
                title: Text(
                  songState.currentSong?.songName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  songState.currentSong?.songArtist ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        ref.read(songsProvider.notifier).previousSong();
                      },
                    ),
                    IconButton(
                      icon: songState.isPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                      onPressed: () {
                        if (songState.currentSong == null) return;

                        if (songState.isPlaying) {
                          ref.read(songsProvider.notifier).pauseSong();
                        } else {
                          ref.read(songsProvider.notifier).resumeSong();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        ref.read(songsProvider.notifier).nextSong();
                      },
                    ),
                  ],
                ),
                onTap: () {
                  context.router.push(const PlayerRoute());
                },
              ),
            )
          : null,
    );
  }
}
