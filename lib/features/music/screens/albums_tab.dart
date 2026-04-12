// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:music_player/providers/songs_provider.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class AlbumsTab extends ConsumerStatefulWidget {
//   const AlbumsTab({super.key});

//   @override
//   ConsumerState<AlbumsTab> createState() => _AlbumsTabState();
// }

// class _AlbumsTabState extends ConsumerState<AlbumsTab> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   bool _isDetailView = false;
//   int? _currentAlbumId;
//   String? _currentAlbumName;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(songsProvider.notifier).fetchAlbums();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(songsProvider);
//     final notifier = ref.read(songsProvider.notifier);

//     if (_isDetailView && _currentAlbumId != null) {
//       return _buildAlbumDetailView(state, notifier);
//     }

//     return _buildAlbumListView(state, notifier);
//   }

//   // ================= ALBUM LIST VIEW (Tile Format) =================
//   Widget _buildAlbumListView(SongsState state, SongsNotifier notifier) {
//     final filteredAlbums = notifier.albums.where((album) {
//       if (_searchQuery.isEmpty) return true;
//       final query = _searchQuery.toLowerCase();
//       return (album.album?.toLowerCase() ?? '').contains(query) ||
//           (album.artist?.toLowerCase() ?? '').contains(query);
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Albums')),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) => setState(() => _searchQuery = value),
//               decoration: InputDecoration(
//                 hintText: 'Search albums or artists...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//               ),
//             ),
//           ),

//           Expanded(
//             child: notifier.albums.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : filteredAlbums.isEmpty
//                 ? const Center(child: Text('No albums found'))
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: filteredAlbums.length,
//                     itemBuilder: (context, index) {
//                       final album = filteredAlbums[index];

//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(8),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: SizedBox(
//                               width: 70,
//                               height: 70,
//                               child: QueryArtworkWidget(
//                                 id: album.id,
//                                 type: ArtworkType.ALBUM,
//                                 artworkWidth: 70,
//                                 artworkHeight: 70,
//                                 artworkFit: BoxFit.cover,
//                                 keepOldArtwork: true,

//                                 artworkBorder: BorderRadius.zero,
//                                 nullArtworkWidget: Container(
//                                   width: 70,
//                                   height: 70,
//                                   color: Colors.grey[800],
//                                   child: const Icon(
//                                     Icons.album,
//                                     size: 40,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             album.album ?? 'Unknown Album',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 album.artist ?? 'Unknown Artist',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 '${album.numOfSongs} songs', // Correct property name
//                                 style: TextStyle(
//                                   color: Colors.grey[500],
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _currentAlbumId = album.id;
//                               _currentAlbumName =
//                                   album.album ?? 'Unknown Album';
//                               _isDetailView = true;
//                             });
//                           },
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= ALBUM DETAIL VIEW =================
//   Widget _buildAlbumDetailView(SongsState state, SongsNotifier notifier) {
//     final songsInAlbum = notifier.getSongsInAlbum(_currentAlbumId!);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_currentAlbumName ?? 'Album'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => setState(() => _isDetailView = false),
//         ),
//       ),
//       body: songsInAlbum.isEmpty
//           ? const Center(child: Text('No songs found in this album'))
//           : Column(
//               children: [
//                 // Play All Button
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       if (songsInAlbum.isNotEmpty) {
//                         final idx = state.allSongs.indexWhere(
//                           (s) => s.songID == songsInAlbum.first.songID,
//                         );
//                         if (idx != -1) notifier.playSong(idx);
//                       }
//                     },
//                     icon: const Icon(Icons.play_arrow),
//                     label: const Text('Play All'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 52),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Songs List
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: songsInAlbum.length,
//                     itemBuilder: (context, index) {
//                       final song = songsInAlbum[index];
//                       final isCurrentlyPlaying =
//                           state.currentSong?.songID == song.songID;

//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 8),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 4,
//                           ),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: SizedBox(
//                               width: 55,
//                               height: 55,
//                               child: QueryArtworkWidget(
//                                 id: song.songID,
//                                 type: ArtworkType.AUDIO,
//                                 artworkWidth: 55,
//                                 artworkHeight: 55,
//                                 artworkFit: BoxFit.cover,
//                                 keepOldArtwork: true,

//                                 nullArtworkWidget: Container(
//                                   color: Colors.grey[800],
//                                   child: const Icon(Icons.music_note, size: 30),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             song.songName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontWeight: isCurrentlyPlaying
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               color: isCurrentlyPlaying
//                                   ? Theme.of(context).colorScheme.primary
//                                   : null,
//                             ),
//                           ),
//                           subtitle: Text(
//                             song.songArtist,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           onTap: () {
//                             final originalIndex = state.allSongs.indexWhere(
//                               (s) => s.songID == song.songID,
//                             );
//                             if (originalIndex != -1) {
//                               notifier.playSong(originalIndex);
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/features/music/providers/albums_provider.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsTab extends ConsumerStatefulWidget {
  const AlbumsTab({super.key});

  @override
  ConsumerState<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends ConsumerState<AlbumsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDetailView = false;
  int? _currentAlbumId;
  String? _currentAlbumName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch albums using its own provider
      ref.read(albumsProvider.notifier).fetchAlbums();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch only what's needed
    final songsState = ref.watch(songsProvider);
    final albumsNotifier = ref.read(albumsProvider.notifier);
    final albumsState = ref.watch(albumsProvider); // Watch albums state if needed

    if (_isDetailView && _currentAlbumId != null) {
      return _buildAlbumDetailView(songsState, albumsNotifier);
    }

    return _buildAlbumListView(songsState, albumsNotifier, albumsState);
  }

  // ================= ALBUM LIST VIEW =================
  Widget _buildAlbumListView(
    SongsState songsState,
    AlbumsNotifier albumsNotifier,
    AlbumsState albumsState,
  ) {
    final filteredAlbums = albumsNotifier.albums.where((album) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return (album.album?.toLowerCase() ?? '').contains(query) ||
          (album.artist?.toLowerCase() ?? '').contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search albums or artists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),

          Expanded(
            child: albumsState.albums.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredAlbums.isEmpty
                    ? const Center(child: Text('No albums found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredAlbums.length,
                        itemBuilder: (context, index) {
                          final album = filteredAlbums[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: QueryArtworkWidget(
                                    id: album.id,
                                    type: ArtworkType.ALBUM,
                                    artworkWidth: 70,
                                    artworkHeight: 70,
                                    artworkFit: BoxFit.cover,
                                    keepOldArtwork: true,
                                    nullArtworkWidget: Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.album,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                album.album ?? 'Unknown Album',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    album.artist ?? 'Unknown Artist',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${album.numOfSongs} songs',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _currentAlbumId = album.id;
                                  _currentAlbumName = album.album ?? 'Unknown Album';
                                  _isDetailView = true;
                                });
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ================= ALBUM DETAIL VIEW =================
  Widget _buildAlbumDetailView(SongsState songsState, AlbumsNotifier albumsNotifier) {
    final songsInAlbum = albumsNotifier.getSongsInAlbum(_currentAlbumId!);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentAlbumName ?? 'Album'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _isDetailView = false),
        ),
      ),
      body: songsInAlbum.isEmpty
          ? const Center(child: Text('No songs found in this album'))
          : Column(
              children: [
                // Play All Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (songsInAlbum.isNotEmpty) {
                        ref.read(songsProvider.notifier).playFromQueue(          // Note: This should be in SongsNotifier
                          song: songsInAlbum.first,
                          queue: songsInAlbum,
                          queueType: QueueType.album,
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play All'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // Songs List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: songsInAlbum.length,
                    itemBuilder: (context, index) {
                      final song = songsInAlbum[index];
                      final isCurrentlyPlaying = songsState.currentSong?.songID == song.songID;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: QueryArtworkWidget(
                                id: song.songID,
                                type: ArtworkType.AUDIO,
                                artworkWidth: 55,
                                artworkHeight: 55,
                                artworkFit: BoxFit.cover,
                                keepOldArtwork: true,
                                nullArtworkWidget: Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.music_note, size: 30),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            song.songName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal,
                              color: isCurrentlyPlaying
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            song.songArtist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            ref.read(songsProvider.notifier).playFromQueue(     // Should be from SongsNotifier
                              song: song,
                              queue: songsInAlbum,
                              queueType: QueueType.album,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}