// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:music_player/models/.playlist.dart';
// import 'package:music_player/models/song.dart';
// import 'package:music_player/providers/songs_provider.dart'; // adjust path if needed

// class PlaylistTab extends ConsumerStatefulWidget {
//   const PlaylistTab({super.key});

//   @override
//   ConsumerState<PlaylistTab> createState() => _PlaylistTabState();
// }

// class _PlaylistTabState extends ConsumerState<PlaylistTab> {
//   bool _isDetailView = false;
//   String? _currentPlaylistId;

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(songsProvider);
//     final notifier = ref.read(songsProvider.notifier);

//     if (_isDetailView && _currentPlaylistId != null) {
//       return _buildPlaylistDetailView(state, notifier);
//     }

//     return _buildPlaylistListView(state, notifier);
//   }

//   // ================= MAIN PLAYLIST LIST VIEW =================
//   Widget _buildPlaylistListView(SongsState state, SongsNotifier notifier) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Playlists')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showCreatePlaylistDialog(notifier),
//         child: const Icon(Icons.add),
//       ),
//       body: state.userPlaylists.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.queue_music, size: 80, color: Colors.grey),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'No playlists yet',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Create your first playlist!',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.userPlaylists.length,
//               itemBuilder: (context, index) {
//                 final playlist = state.userPlaylists[index];
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
//                         _currentPlaylistId = playlist.id;
//                         _isDetailView = true;
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   // ================= PLAYLIST DETAIL VIEW =================
//   Widget _buildPlaylistDetailView(SongsState state, SongsNotifier notifier) {
//     final playlist = state.userPlaylists.firstWhere(
//       (p) => p.id == _currentPlaylistId,
//     );
//     final songsInPlaylist = notifier.getSongsInPlaylist(playlist.id);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(playlist.name),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => setState(() => _isDetailView = false),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () => _showRenamePlaylistDialog(playlist, notifier),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => _showDeletePlaylistDialog(playlist, notifier),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () =>
//             _showAddSongsDialog(playlist, notifier, state.allSongs),
//         child: const Icon(Icons.add),
//       ),
//       body: songsInPlaylist.isEmpty
//           ? const Center(
//               child: Text('This playlist is empty\nTap + to add songs'),
//             )
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       if (songsInPlaylist.isNotEmpty) {
//                         final idx = state.allSongs.indexWhere(
//                           (s) => s.songID == songsInPlaylist.first.songID,
//                         );
//                         if (idx != -1) notifier.playSong(idx);
//                       }
//                     },
//                     icon: const Icon(Icons.play_arrow),
//                     label: const Text('Play All'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: songsInPlaylist.length,
//                     itemBuilder: (context, index) {
//                       final song = songsInPlaylist[index];
//                       final isPlaying =
//                           state.currentSong?.songID == song.songID;

//                       return ListTile(
//                         leading: const Icon(Icons.music_note),
//                         title: Text(
//                           song.songName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         subtitle: Text(song.songArtist),
//                         trailing: IconButton(
//                           icon: const Icon(
//                             Icons.remove_circle_outline,
//                             color: Colors.red,
//                           ),
//                           onPressed: () => notifier.removeSongFromPlaylist(
//                             playlist.id,
//                             song.songID,
//                           ),
//                         ),
//                         onTap: () {
//                           final originalIndex = state.allSongs.indexWhere(
//                             (s) => s.songID == song.songID,
//                           );
//                           if (originalIndex != -1)
//                             notifier.playSong(originalIndex);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   // ================= DIALOGS =================
//   void _showCreatePlaylistDialog(SongsNotifier notifier) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('New Playlist'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: 'Playlist name'),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (controller.text.trim().isNotEmpty) {
//                 notifier.createPlaylist(controller.text.trim());
//               }
//               Navigator.pop(ctx);
//             },
//             child: const Text('Create'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRenamePlaylistDialog(Playlist playlist, SongsNotifier notifier) {
//     final controller = TextEditingController(text: playlist.name);
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Rename Playlist'),
//         content: TextField(controller: controller, autofocus: true),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (controller.text.trim().isNotEmpty) {
//                 notifier.renamePlaylist(playlist.id, controller.text.trim());
//               }
//               Navigator.pop(ctx);
//               setState(() {}); // refresh UI
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeletePlaylistDialog(Playlist playlist, SongsNotifier notifier) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Playlist?'),
//         content: Text('Delete "${playlist.name}" permanently?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               notifier.deletePlaylist(playlist.id);
//               Navigator.pop(ctx);
//               setState(() {
//                 _isDetailView = false;
//                 _currentPlaylistId = null;
//               });
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddSongsDialog(
//     Playlist playlist,
//     SongsNotifier notifier,
//     List<Song> allSongs,
//   ) {
//     final songsNotInPlaylist = allSongs
//         .where((song) => !playlist.songIds.contains(song.songID))
//         .toList();
//     final TextEditingController searchCtrl = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setInnerState) {
//             final filtered = songsNotInPlaylist.where((song) {
//               final query = searchCtrl.text.toLowerCase();
//               return query.isEmpty ||
//                   song.songName.toLowerCase().contains(query) ||
//                   song.songArtist.toLowerCase().contains(query);
//             }).toList();

//             return AlertDialog(
//               title: const Text('Add Songs'),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 height: 400,
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: searchCtrl,
//                       decoration: const InputDecoration(
//                         hintText: 'Search songs...',
//                       ),
//                       onChanged: (_) => setInnerState(() {}),
//                     ),
//                     Expanded(
//                       child: filtered.isEmpty
//                           ? const Center(child: Text('No songs found'))
//                           : ListView.builder(
//                               itemCount: filtered.length,
//                               itemBuilder: (context, i) {
//                                 final song = filtered[i];
//                                 return ListTile(
//                                   title: Text(song.songName),
//                                   subtitle: Text(song.songArtist),
//                                   onTap: () {
//                                     notifier.addSongToPlaylist(
//                                       playlist.id,
//                                       song.songID,
//                                     );
//                                     Navigator.pop(ctx);
//                                   },
//                                 );
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(ctx),
//                   child: const Text('Close'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/models/.playlist.dart'; // Fixed import (removed dot)
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/features/music/widgets/create_playlist.dart';

class PlaylistTab extends ConsumerStatefulWidget {
  const PlaylistTab({super.key});

  @override
  ConsumerState<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends ConsumerState<PlaylistTab> {
  bool _isDetailView = false;
  String? _currentPlaylistId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(songsProvider);
    final notifier = ref.read(songsProvider.notifier);

    if (_isDetailView && _currentPlaylistId != null) {
      return _buildPlaylistDetailView(state, notifier);
    }

    return _buildPlaylistListView(state, notifier);
  }

  // ================= MAIN PLAYLIST LIST VIEW =================
  Widget _buildPlaylistListView(SongsState state, SongsNotifier notifier) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CreatePlaylist();
            },
          );

          // showDialog(
          //     context: context,
          //     builder:
        },
        child: const Icon(Icons.add),
      ),
      body: state.userPlaylists.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.queue_music, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No playlists yet',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first playlist!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.userPlaylists.length,
              itemBuilder: (context, index) {
                final playlist = state.userPlaylists[index];
                final songCount = playlist.songIds.length;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.queue_music, size: 40),
                    title: Text(
                      playlist.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text('$songCount songs'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      setState(() {
                        _currentPlaylistId = playlist.id;
                        _isDetailView = true;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }

  // ================= PLAYLIST DETAIL VIEW (Updated with Queue) =================
  Widget _buildPlaylistDetailView(SongsState state, SongsNotifier notifier) {
    final playlist = state.userPlaylists.firstWhere(
      (p) => p.id == _currentPlaylistId,
    );
    final songsInPlaylist = notifier.getSongsInPlaylist(playlist.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _isDetailView = false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showRenamePlaylistDialog(playlist, notifier),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeletePlaylistDialog(playlist, notifier),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddSongsDialog(playlist, notifier, state.allSongs),
        child: const Icon(Icons.add),
      ),
      body: songsInPlaylist.isEmpty
          ? const Center(
              child: Text('This playlist is empty\nTap + to add songs'),
            )
          : Column(
              children: [
                // Play All Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (songsInPlaylist.isNotEmpty) {
                        // ✅ Correct: Use playlist songs as queue
                        notifier.playFromQueue(
                          song: songsInPlaylist.first,
                          queue: songsInPlaylist,
                          queueType: QueueType.playlist,
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play All'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
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
                          state.currentSong?.songID == song.songID;

                      return ListTile(
                        leading: const Icon(Icons.music_note),
                        title: Text(
                          song.songName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(song.songArtist),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => notifier.removeSongFromPlaylist(
                            playlist.id,
                            song.songID,
                          ),
                        ),
                        onTap: () {
                          // ✅ Correct: Play with playlist as queue
                          notifier.playFromQueue(
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
    );
  }

  // ================= DIALOGS (Unchanged) =================
  // void _showCreatePlaylistDialog(SongsNotifier notifier) {
  //   final controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('New Playlist'),
  //       content: TextField(
  //         controller: controller,
  //         decoration: const InputDecoration(hintText: 'Playlist name'),
  //         autofocus: true,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             if (controller.text.trim().isNotEmpty) {
  //               notifier.createPlaylist(controller.text.trim());
  //             }
  //             Navigator.pop(ctx);
  //           },
  //           child: const Text('Create'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showRenamePlaylistDialog(Playlist playlist, SongsNotifier notifier) {
    final controller = TextEditingController(text: playlist.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Playlist'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                notifier.renamePlaylist(playlist.id, controller.text.trim());
              }
              Navigator.pop(ctx);
              setState(() {}); // refresh UI
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeletePlaylistDialog(Playlist playlist, SongsNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Playlist?'),
        content: Text('Delete "${playlist.name}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
    SongsNotifier notifier,
    List<Song> allSongs,
  ) {
    final songsNotInPlaylist = allSongs
        .where((song) => !playlist.songIds.contains(song.songID))
        .toList();
    final TextEditingController searchCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            final filtered = songsNotInPlaylist.where((song) {
              final query = searchCtrl.text.toLowerCase();
              return query.isEmpty ||
                  song.songName.toLowerCase().contains(query) ||
                  song.songArtist.toLowerCase().contains(query);
            }).toList();

            return AlertDialog(
              title: const Text('Add Songs'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Search songs...',
                      ),
                      onChanged: (_) => setInnerState(() {}),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('No songs found'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final song = filtered[i];
                                return ListTile(
                                  title: Text(song.songName),
                                  subtitle: Text(song.songArtist),
                                  onTap: () {
                                    notifier.addSongToPlaylist(
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
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
