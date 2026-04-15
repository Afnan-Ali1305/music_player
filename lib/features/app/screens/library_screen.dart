// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:music_player/core/extensions/app_extensions.dart';
// import 'package:music_player/features/music/providers/playlists_provider.dart';
// import 'package:music_player/features/music/providers/songs_provider.dart';
// import 'package:music_player/features/music/widgets/create_playlist.dart';

// @RoutePage()
// class LibraryScreen extends ConsumerStatefulWidget {
//   const LibraryScreen({super.key});

//   @override
//   ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
// }

// class _LibraryScreenState extends ConsumerState<LibraryScreen> {
//   bool isDetailView = false;
//   String? currentPlaylistId;
//   @override
//   Widget build(BuildContext context) {
//     final songsState = ref.watch(songsProvider);
//     final playlistsState = ref.watch(playlistsProvider);

//     final songsNotifier = ref.read(songsProvider.notifier);
//     final playlistsNotifier = ref.read(playlistsProvider.notifier);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Library", style: context.textTheme.titleLarge),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => const CreatePlaylist(),
//                 );
//               },
//               icon: Icon(Icons.add, size: 35),
//             ),
//           ),
//         ],
//       ),
//       body: playlistsState.playlists.isEmpty
//           ? const Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.queue_music, size: 80, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text('No playlists yet', style: TextStyle(fontSize: 20)),
//                   SizedBox(height: 8),
//                   Text(
//                     'Create your first playlist!',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: playlistsState.playlists.length,
//               itemBuilder: (context, index) {
//                 final playlist = playlistsState.playlists[index];
//                 final songCount = playlist.songIds.length;

//                 return Card(
//                   child: ListTile(
//                     leading: const Icon(Icons.queue_music, size: 40),
//                     title: Text(
//                       playlist.name,
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                     subtitle: Text('$songCount songs'),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () {
//                       setState(() {
//                         currentPlaylistId = playlist.id;
//                         isDetailView = true;
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// main_playlist_tab.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:music_player/features/app/widgets/playlist_detail_view.dart';
// import 'package:music_player/features/app/widgets/playlist_listview.dart';

// class LibraryScreen extends ConsumerStatefulWidget {
//   const LibraryScreen({super.key});

//   @override
//   ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
// }

// class _LibraryScreenState extends ConsumerState<LibraryScreen> {
//   bool _isDetailView = false;
//   String? _currentPlaylistId;

//   @override
//   Widget build(BuildContext context) {
//     if (_isDetailView && _currentPlaylistId != null) {
//       return PlaylistDetailView(
//         playlistId: _currentPlaylistId!,
//         onBack: () {
//           setState(() {
//             _isDetailView = false;
//             _currentPlaylistId = null;
//           });
//         },
//       );
//     }

//     return PlaylistListView(
//       onPlaylistTap: (playlistId) {
//         setState(() {
//           _currentPlaylistId = playlistId;
//           _isDetailView = true;
//         });
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/data/models/.playlist.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/music/providers/playlists_provider.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/features/music/widgets/create_playlist.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isDetailView = false;
  String? _currentPlaylistId;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsProvider);
    final playlistsState = ref.watch(playlistsProvider);

    final songsNotifier = ref.read(songsProvider.notifier);
    final playlistsNotifier = ref.read(playlistsProvider.notifier);

    if (_isDetailView && _currentPlaylistId != null) {
      return _buildPlaylistDetailView(
        songsState: songsState,
        playlistsState: playlistsState,
        songsNotifier: songsNotifier,
        playlistsNotifier: playlistsNotifier,
      );
    }

    return _buildPlaylistListView(playlistsState, playlistsNotifier);
  }

  // ================= SPOTIFY-LIKE PLAYLIST LIST VIEW =================
  Widget _buildPlaylistListView(
    PlaylistsState playlistsState,
    PlaylistsNotifier playlistsNotifier,
  ) {
    // Filter playlists based on search
    final filteredPlaylists = _searchQuery.isEmpty
        ? playlistsState.playlists
        : playlistsState.playlists
              .where(
                (playlist) => playlist.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Your Library',
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreatePlaylist(),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              // style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search playlists...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                // fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: filteredPlaylists.isEmpty
          ? _buildEmptyLibrary()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPlaylists.length,
              itemBuilder: (context, index) {
                final playlist = filteredPlaylists[index];
                final songCount = playlist.songIds.length;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPlaylistId = playlist.id;
                      _isDetailView = true;
                    });
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),

                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey[850]!, Colors.grey[900]!],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(Icons.queue_music, color: Colors.grey[700]),
                    ),

                    title: Text(
                      playlist.name,
                      style: context.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Text(
                      'Playlist • $songCount songs',
                      style: context.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyLibrary() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              // color: Colors.grey[900],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.library_music,
              size: 50,
              // color: Colors.grey,
            ),
          ),
          const Gap(24),
          Text(
            'Create your first playlist',
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Save your favorite songs in a playlist',
            style: context.textTheme.bodyMedium,
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreatePlaylist(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Playlist'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SPOTIFY-LIKE PLAYLIST DETAIL VIEW =================
  Widget _buildPlaylistDetailView({
    required SongsState songsState,
    required PlaylistsState playlistsState,
    required SongsNotifier songsNotifier,
    required PlaylistsNotifier playlistsNotifier,
  }) {
    final playlist = playlistsState.playlists.firstWhere(
      (p) => p.id == _currentPlaylistId,
    );

    final songsInPlaylist = playlistsNotifier.getSongsInPlaylist(playlist.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _isDetailView = false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                _showRenamePlaylistDialog(playlist, playlistsNotifier),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () =>
                _showDeletePlaylistDialog(playlist, playlistsNotifier),
          ),
        ],
      ),
      body: songsInPlaylist.isEmpty
          ? _buildEmptyPlaylistDetail()
          : Column(
              children: [
                // Spotify-like playlist header
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[850]!, Colors.black],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.queue_music,
                        size: 80,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        playlist.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${songsInPlaylist.length} songs',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Play All Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (songsInPlaylist.isNotEmpty) {
                        songsNotifier.playFromQueue(
                          song: songsInPlaylist.first,
                          queue: songsInPlaylist,
                          queueType: QueueType.playlist,
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'PLAY ALL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),

                // Songs List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: songsInPlaylist.length,
                    itemBuilder: (context, index) {
                      final song = songsInPlaylist[index];
                      final isPlaying =
                          songsState.currentSong?.songID == song.songID;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          child: Icon(
                            Icons.music_note,
                            color: isPlaying ? Colors.green : Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          song.songName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPlaying ? Colors.green : Colors.white,
                            fontWeight: isPlaying ? FontWeight.bold : null,
                          ),
                        ),
                        subtitle: Text(
                          song.songArtist,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => playlistsNotifier
                              .removeSongFromPlaylist(playlist.id, song.songID),
                        ),
                        onTap: () {
                          songsNotifier.playFromQueue(
                            song: song,
                            queue: songsInPlaylist,
                            queueType: QueueType.playlist,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: songsInPlaylist.isEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddSongsDialog(
                playlist,
                playlistsNotifier,
                songsState.allSongs,
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildEmptyPlaylistDetail() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text('This playlist is empty', style: context.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add songs',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ================= DIALOGS =================
  void _showRenamePlaylistDialog(
    Playlist playlist,
    PlaylistsNotifier notifier,
  ) {
    final controller = TextEditingController(text: playlist.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Rename Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                notifier.renamePlaylist(playlist.id, controller.text.trim());
              }
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showDeletePlaylistDialog(
    Playlist playlist,
    PlaylistsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Playlist?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete "${playlist.name}" permanently?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              notifier.deletePlaylist(playlist.id);
              Navigator.pop(ctx);
              setState(() {
                _isDetailView = false;
                _currentPlaylistId = null;
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddSongsDialog(
    Playlist playlist,
    PlaylistsNotifier playlistsNotifier,
    List<Song> allSongs,
  ) {
    final songsNotInPlaylist = allSongs
        .where((song) => !playlist.songIds.contains(song.songID))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            final searchCtrl = TextEditingController();

            final filtered = songsNotInPlaylist.where((song) {
              final query = searchCtrl.text.toLowerCase();
              return query.isEmpty ||
                  song.songName.toLowerCase().contains(query) ||
                  song.songArtist.toLowerCase().contains(query);
            }).toList();

            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Add Songs',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search songs...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setInnerState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text(
                                'No songs found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final song = filtered[i];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.music_note,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    song.songName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    song.songArtist,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  onTap: () {
                                    playlistsNotifier.addSongToPlaylist(
                                      playlist.id,
                                      song.songID,
                                    );
                                    Navigator.pop(ctx);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
