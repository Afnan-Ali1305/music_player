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
//           title: Text("Musify", style: context.textTheme.titleLarge),
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
import 'package:gap/gap.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/core/router/app_router.gr.dart';
import 'package:music_player/features/music/screens/favourite_songs_tab.dart';
import 'package:music_player/features/music/screens/play_list_tab.dart';
import 'package:music_player/features/music/screens/albums_tab.dart';
import 'package:music_player/features/music/screens/songs_tab.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/features/user/provider/user_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsProvider.notifier).fetchAllSongs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(songsProvider);
    final textTheme = context.textTheme;
    final userState = ref.watch(userProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive Brand Colors
    final primaryColor = AppColors.brandGold; // #FFC107 - Main accent
    final charcoal = AppColors.brandCharcoal; // #212121
    final textPrimary = isDark ? Colors.white : charcoal;
    final textSecondary = isDark ? Colors.white70 : charcoal.withOpacity(0.75);

    return Scaffold(
      // ====================== APP BAR ======================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [charcoal.withOpacity(0.95), Colors.black87]
                  : [Colors.white, Colors.white.withOpacity(0.98)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          userState.userName ?? "Musify",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => context.router.push(const SettingsRoute()),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor.withOpacity(0.12),
                child: userState.profilePicture != null
                    ? ClipOval(
                        child: Image.memory(
                          userState.profilePicture!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.person, size: 26, color: textPrimary),
              ),
            ),
          ),
        ],
      ),

      body: songState.isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : !songState.hasPermission
          ? //_buildPermissionScreen(textPrimary, textSecondary, primaryColor)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_note_outlined,
                      size: 90,
                      color: primaryColor.withOpacity(0.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Storage Permission Required",
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Please allow access to your music files",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.folder_open),
                      label: const Text("Grant Permission"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () =>
                          ref.read(songsProvider.notifier).fetchAllSongs(),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // ==================== RECENTLY PLAYED ====================
                if (songState.recentlyPlayedSongs.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recently Played",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 195,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: songState.recentlyPlayedSongs.length,
                            itemBuilder: (context, index) {
                              final song = songState.recentlyPlayedSongs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: SizedBox(
                                  width: 148,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      ref
                                          .read(songsProvider.notifier)
                                          .playFromQueue(
                                            song: song,
                                            queue:
                                                songState.recentlyPlayedSongs,
                                            queueType: QueueType.allSongs,
                                          );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor.withOpacity(
                                                  0.25,
                                                ),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: QueryArtworkWidget(
                                            id: song.songID,
                                            type: ArtworkType.AUDIO,
                                            artworkHeight: 148,
                                            artworkWidth: 148,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(16),
                                            keepOldArtwork: true,
                                            nullArtworkWidget: Container(
                                              height: 148,
                                              width: 148,
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? charcoal
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Icon(
                                                Icons.music_note,
                                                size: 72,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          song.songName,
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                          ),
                                          // maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          song.songArtist,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: textSecondary,
                                          ),
                                          // maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ====================== TABS ======================
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  labelStyle: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: textTheme.titleSmall,
                  labelColor: primaryColor,
                  unselectedLabelColor: textSecondary,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3.5,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
                  tabs: const [
                    Tab(text: "All Songs"),
                    Tab(text: "Favourites"),
                    Tab(text: "Playlist"),
                    Tab(text: "Albums"),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      SongsTab(),
                      FavouriteSongsTab(),
                      PlaylistTab(),
                      AlbumsTab(),
                    ],
                  ),
                ),
              ],
            ),

      // ====================== MINI PLAYER ======================
      bottomNavigationBar: songState.currentSong != null
          ? Container(
              height: 78,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: QueryArtworkWidget(
                    id: songState.currentSong!.songID,
                    type: ArtworkType.AUDIO,
                    artworkHeight: 54,
                    artworkWidth: 54,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(12),
                    keepOldArtwork: true,
                    nullArtworkWidget: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isDark ? charcoal : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.music_note,
                        size: 32,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  songState.currentSong?.songName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                subtitle: Text(
                  songState.currentSong?.songArtist ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: textSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      color: textPrimary,
                      iconSize: 28,
                      onPressed: () =>
                          ref.read(songsProvider.notifier).previousSong(),
                    ),
                    IconButton(
                      icon: songState.isPlaying
                          ? const Icon(Icons.pause_rounded)
                          : const Icon(Icons.play_arrow_rounded),
                      color: primaryColor,
                      iconSize: 36,
                      onPressed: () {
                        final notifier = ref.read(songsProvider.notifier);
                        songState.isPlaying
                            ? notifier.pauseSong()
                            : notifier.resumeSong();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      color: textPrimary,
                      iconSize: 28,
                      onPressed: () =>
                          ref.read(songsProvider.notifier).nextSong(),
                    ),
                  ],
                ),
                onTap: () => context.router.push(const PlayerRoute()),
              ),
            )
          : null,
    );
  }

  // Permission Screen
}
