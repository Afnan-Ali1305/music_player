// import 'package:flutter_riverpod/legacy.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:music_player/Database/local_storage.dart';
// import 'package:music_player/models/.playlist.dart';
// import 'package:music_player/models/song.dart';
// import 'package:music_player/permissions/audio_permission.dart';
// import 'package:music_player/services/audio_player_services.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// final songsProvider = StateNotifierProvider<SongsNotifier, SongsState>((ref) {
//   return SongsNotifier();
// });

// class SongsNotifier extends StateNotifier<SongsState> {
//   final OnAudioQuery audioQuery = OnAudioQuery();
//   final AudioPlayerService playerService = AudioPlayerService();

//   SongsNotifier()
//     : super(
//         SongsState(
//           allSongs: [],
//           recentlyPlayedSongs: [],
//           isLoading: true,
//           hasPermission: false,
//         ),
//       ) {
//     _init();
//   }

//   Future<void> _init() async {
//     await loadFavourites();
//     await loadPlaylists();
//     await fetchAlbums();
//     playerService.positionStream.listen((position) {
//       state = state.copyWith(currentSongPosition: position);
//     });

//     playerService.durationStream.listen((duration) {
//       state = state.copyWith(currentSongDuration: duration ?? Duration.zero);
//     });

//     playerService.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         if (state.isRepeat) {
//           // 🔁 Repeat same song
//           if (state.currentSong != null) {
//             playerService.seek(Duration.zero);
//             playerService.playSong(state.currentSong!.songPath);
//           }
//         } else {
//           // ▶️ Next song
//           nextSong();
//         }
//       }
//     });
//   }

//   // ================= FETCH SONGS =================

//   Future<void> fetchAllSongs() async {
//     final permission = await AudioPermission.request();

//     if (!permission) {
//       state = state.copyWith(hasPermission: false, isLoading: false);
//       return;
//     }

//     final loadedSongs = await audioQuery.querySongs(
//       sortType: SongSortType.DATE_ADDED,
//       orderType: OrderType.DESC_OR_GREATER,
//       uriType: UriType.EXTERNAL,
//       ignoreCase: true,
//     );

//     final songsList = loadedSongs
//         .map(
//           (s) => Song(
//             songID: s.id,
//             songArtist: s.artist ?? "Artist Name",
//             songName: s.title,
//             songPath: s.uri!,
//             albumId: s.albumId,
//           ),
//         )
//         .toList();

//     // Load recently played from Hive and map to real Song objects
//     final recentIds = LocalStorage.getRecentlyPlayedIds();
//     final recentSongs =
//         songsList.where((song) => recentIds.contains(song.songID)).toList()
//           ..sort(
//             (a, b) => recentIds.indexOf(a.songID) - recentIds.indexOf(b.songID),
//           );

//     state = state.copyWith(
//       allSongs: songsList,
//       recentlyPlayedSongs: recentSongs, //songsList.take(2).toList(),
//       isLoading: false,
//       hasPermission: true,
//     );
//   }

//   // ================= RECENTLY PLAYED (NEW) =================
//   void _addToRecentlyPlayed(Song song) {
//     final currentRecent = List<Song>.from(state.recentlyPlayedSongs);

//     // Remove if already exists
//     currentRecent.removeWhere((s) => s.songID == song.songID);

//     // Add to front
//     currentRecent.insert(0, song);

//     // Keep only 10
//     if (currentRecent.length > 10) {
//       currentRecent.removeLast();
//     }

//     state = state.copyWith(recentlyPlayedSongs: currentRecent);

//     // Save IDs to Hive
//     final ids = currentRecent.map((s) => s.songID).toList();
//     LocalStorage.saveRecentlyPlayed(ids);
//   }
//   // ================= PLAYER =================

//   void playSong(int index) {
//     final song = state.allSongs[index];

//     playerService.playSong(song.songPath);

//     state = state.copyWith(
//       currentSong: song,
//       currentSongIndex: index,
//       isPlaying: true,
//     );

//     _addToRecentlyPlayed(song);
//   }

//   void pauseSong() {
//     playerService.pause();
//     state = state.copyWith(isPlaying: false);
//   }

//   void resumeSong() {
//     playerService.resume();
//     state = state.copyWith(isPlaying: true);
//   }

//   void nextSong() {
//     if (state.currentSongIndex == null) return;

//     final nextIndex = state.currentSongIndex! + 1;

//     if (nextIndex < state.allSongs.length) {
//       playSong(nextIndex);
//     }
//   }

//   void previousSong() {
//     if (state.currentSongIndex == null) return;

//     final prevIndex = state.currentSongIndex! - 1;

//     if (prevIndex >= 0) {
//       playSong(prevIndex);
//     }
//   }

//   void seekTo(Duration position) {
//     if (state.currentSong == null) return;

//     playerService.seek(position);
//     state = state.copyWith(currentSongPosition: position);
//   }

//   // ================= FAVOURITES =================

//   List<Song> get favouriteSongs {
//     return state.allSongs
//         .where((song) => state.favouriteMap[song.songID] == true)
//         .toList();
//   }

//   void toggleFavourite(int songID) async {
//     final currentStatus = state.favouriteMap[songID] ?? false;

//     final newMap = {...state.favouriteMap, songID: !currentStatus};

//     state = state.copyWith(favouriteMap: newMap);

//     await LocalStorage.setFavouriteMap(newMap);
//   }

//   Future<void> loadFavourites() async {
//     final favMap = LocalStorage.getFavouriteMap();
//     state = state.copyWith(favouriteMap: favMap);
//   }

//   void toggleRepeat() {
//     state = state.copyWith(isRepeat: !state.isRepeat);
//   }

//   Future<void> loadPlaylists() async {
//     final playlists = LocalStorage.getPlaylists();
//     state = state.copyWith(userPlaylists: playlists);
//   }

//   Future<void> _savePlaylists() async {
//     await LocalStorage.savePlaylists(state.userPlaylists);
//   }

//   void createPlaylist(String name) {
//     final newPlaylist = Playlist(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: name,
//       songIds: [],
//     );
//     state = state.copyWith(
//       userPlaylists: [...state.userPlaylists, newPlaylist],
//     );
//     _savePlaylists();
//   }

//   void renamePlaylist(String playlistId, String newName) {
//     final updated = state.userPlaylists.map((p) {
//       if (p.id == playlistId) return p.copyWith(name: newName);
//       return p;
//     }).toList();
//     state = state.copyWith(userPlaylists: updated);
//     _savePlaylists();
//   }

//   void deletePlaylist(String playlistId) {
//     final updated = state.userPlaylists
//         .where((p) => p.id != playlistId)
//         .toList();
//     state = state.copyWith(userPlaylists: updated);
//     _savePlaylists();
//   }

//   void addSongToPlaylist(String playlistId, int songId) {
//     final updated = state.userPlaylists.map((p) {
//       if (p.id == playlistId && !p.songIds.contains(songId)) {
//         return p.copyWith(songIds: [...p.songIds, songId]);
//       }
//       return p;
//     }).toList();
//     state = state.copyWith(userPlaylists: updated);
//     _savePlaylists();
//   }

//   void removeSongFromPlaylist(String playlistId, int songId) {
//     final updated = state.userPlaylists.map((p) {
//       if (p.id == playlistId) {
//         return p.copyWith(
//           songIds: p.songIds.where((id) => id != songId).toList(),
//         );
//       }
//       return p;
//     }).toList();
//     state = state.copyWith(userPlaylists: updated);
//     _savePlaylists();
//   }

//   List<Song> getSongsInPlaylist(String playlistId) {
//     try {
//       final playlist = state.userPlaylists.firstWhere(
//         (p) => p.id == playlistId,
//       );
//       return state.allSongs
//           .where((song) => playlist.songIds.contains(song.songID))
//           .toList();
//     } catch (e) {
//       // firstWhere throws StateError if not found
//       return [];
//     }
//   }

//   // ================= albums ========================

//   List<AlbumModel> albums = [];
//   Future<void> fetchAlbums() async {
//     final permission = await AudioPermission.request();
//     if (!permission) return;
//     final loadedAlbums = await audioQuery.queryAlbums(
//       sortType: AlbumSortType.ALBUM,
//       orderType: OrderType.ASC_OR_SMALLER,
//       uriType: UriType.EXTERNAL,
//       ignoreCase: true,
//     );
//     albums = loadedAlbums;
//   }

//   List<Song> getSongsInAlbum(int albumId) {
//     return state.allSongs.where((song) => song.albumId == albumId).toList();
//   }
// }

// // ================= STATE =================

// class SongsState {
//   final List<Song> allSongs;
//   final List<Song> recentlyPlayedSongs;

//   final bool hasPermission;
//   final bool isLoading;

//   final Song? currentSong;
//   final bool isPlaying;
//   final int? currentSongIndex;

//   final Duration currentSongPosition;
//   final Duration currentSongDuration;

//   final Map<int, bool> favouriteMap;

//   final bool isRepeat;
//   final List<Playlist> userPlaylists;
//   SongsState({
//     required this.allSongs,
//     required this.recentlyPlayedSongs,
//     required this.isLoading,
//     required this.hasPermission,
//     this.currentSong,
//     this.isPlaying = false,
//     this.currentSongIndex,
//     this.currentSongDuration = Duration.zero,
//     this.currentSongPosition = Duration.zero,
//     Map<int, bool>? favouriteMap,
//     this.isRepeat = false,
//     List<Playlist>? userPlaylists,
//   }) : favouriteMap = favouriteMap ?? {},
//        userPlaylists = userPlaylists ?? [];

//   SongsState copyWith({
//     List<Song>? allSongs,
//     List<Song>? recentlyPlayedSongs,
//     bool? isLoading,
//     bool? hasPermission,
//     Song? currentSong,
//     bool? isPlaying,
//     int? currentSongIndex,
//     Duration? currentSongDuration,
//     Duration? currentSongPosition,
//     Map<int, bool>? favouriteMap,
//     bool? isRepeat,
//     List<Playlist>? userPlaylists,
//   }) {
//     return SongsState(
//       allSongs: allSongs ?? this.allSongs,
//       recentlyPlayedSongs: recentlyPlayedSongs ?? this.recentlyPlayedSongs,
//       isLoading: isLoading ?? this.isLoading,
//       hasPermission: hasPermission ?? this.hasPermission,
//       currentSong: currentSong ?? this.currentSong,
//       isPlaying: isPlaying ?? this.isPlaying,
//       currentSongIndex: currentSongIndex ?? this.currentSongIndex,
//       currentSongDuration: currentSongDuration ?? this.currentSongDuration,
//       currentSongPosition: currentSongPosition ?? this.currentSongPosition,
//       favouriteMap: favouriteMap ?? this.favouriteMap,
//       isRepeat: isRepeat ?? this.isRepeat,
//       userPlaylists: userPlaylists ?? this.userPlaylists,
//     );
//   }
// }

import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Database/local_storage.dart';
import 'package:music_player/models/.playlist.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/permissions/audio_permission.dart';
import 'package:music_player/services/audio_player_services.dart';
import 'package:on_audio_query/on_audio_query.dart';

final songsProvider = StateNotifierProvider<SongsNotifier, SongsState>((ref) {
  return SongsNotifier();
});

class SongsNotifier extends StateNotifier<SongsState> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayerService playerService = AudioPlayerService();

  SongsNotifier()
    : super(
        SongsState(
          allSongs: [],
          recentlyPlayedSongs: [],
          currentQueue: [],
          queueType: QueueType.allSongs,
          isLoading: true,
          hasPermission: false,
          allSongsDuration: [],
        ),
      ) {
    _init();
  }

  Future<void> _init() async {
    await loadFavourites();
    await loadPlaylists();
    await fetchAlbums();

    // Listen to player streams
    playerService.positionStream.listen((position) {
      state = state.copyWith(currentSongPosition: position);
    });

    playerService.durationStream.listen((duration) {
      state = state.copyWith(currentSongDuration: duration ?? Duration.zero);
    });

    playerService.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (state.isRepeat) {
          if (state.currentSong != null) {
            playerService.seek(Duration.zero);
            playerService.playSong(state.currentSong!.songPath);
          }
        } else {
          nextSong();
        }
      }
    });
  }

  // ================= FETCH SONGS =================
  Future<void> fetchAllSongs() async {
    final permission = await AudioPermission.request();
    if (!permission) {
      state = state.copyWith(hasPermission: false, isLoading: false);
      return;
    }

    final onlyMusic = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    // final loadedSongs = await audioQuery.querySongs(
    //   sortType: SongSortType.DATE_ADDED,
    //   orderType: OrderType.DESC_OR_GREATER,
    //   uriType: UriType.EXTERNAL,
    //   ignoreCase: true,
    // );
    final loadedSongs = onlyMusic.where((song) {
      final path = song.data.toLowerCase();
      return song.isMusic == true &&
          (song.duration ?? 0) > 180000 &&
          !path.contains("whatsapp") &&
          !path.contains("record");
    });
    final songsList = loadedSongs
        .map(
          (s) => Song(
            songID: s.id,
            songArtist: s.artist ?? "Unknown Artist",
            songName: s.title,
            songPath: s.uri!,
            albumId: s.albumId,
          ),
        )
        .toList();

    // Load recently played from Hive
    final recentIds = LocalStorage.getRecentlyPlayedIds();
    final recentSongs =
        songsList.where((song) => recentIds.contains(song.songID)).toList()
          ..sort(
            (a, b) => recentIds.indexOf(a.songID) - recentIds.indexOf(b.songID),
          );
    final durationOfSongs = loadedSongs
        .map((song) => Duration(milliseconds: song.duration ?? 0))
        .toList();
    state = state.copyWith(
      allSongs: songsList,
      recentlyPlayedSongs: recentSongs,
      currentQueue: songsList, // Default queue = all songs
      isLoading: false,
      hasPermission: true,
      allSongsDuration: durationOfSongs,
    );
  }

  // ================= RECENTLY PLAYED =================
  void _addToRecentlyPlayed(Song song) {
    final currentRecent = List<Song>.from(state.recentlyPlayedSongs);

    // Remove duplicate if exists
    currentRecent.removeWhere((s) => s.songID == song.songID);

    // Add to front (newest first)
    currentRecent.insert(0, song);

    // Keep only last 10 songs
    if (currentRecent.length > 10) {
      currentRecent.removeLast();
    }

    state = state.copyWith(recentlyPlayedSongs: currentRecent);

    // Save to Hive
    final ids = currentRecent.map((s) => s.songID).toList();
    LocalStorage.saveRecentlyPlayed(ids);
  }

  // ================= QUEUE MANAGEMENT =================
  void playFromQueue({
    required Song song,
    required List<Song> queue,
    required QueueType queueType,
    int? startingIndex,
  }) {
    final index =
        startingIndex ?? queue.indexWhere((s) => s.songID == song.songID);

    playerService.playSong(song.songPath);

    state = state.copyWith(
      currentSong: song,
      currentSongIndex: index,
      currentQueue: queue,
      queueType: queueType,
      isPlaying: true,
    );

    _addToRecentlyPlayed(song);
  }

  // Legacy method for All Songs tab (backward compatible)
  void playSong(int index) {
    if (index < 0 || index >= state.allSongs.length) return;
    final song = state.allSongs[index];
    playFromQueue(
      song: song,
      queue: state.allSongs,
      queueType: QueueType.allSongs,
      startingIndex: index,
    );
  }

  void pauseSong() {
    playerService.pause();
    state = state.copyWith(isPlaying: false);
  }

  void resumeSong() {
    playerService.resume();
    state = state.copyWith(isPlaying: true);
  }

  void nextSong() {
    if (state.currentSongIndex == null || state.currentQueue.isEmpty) return;

    int nextIndex = state.currentSongIndex! + 1;
    if (nextIndex >= state.currentQueue.length) {
      nextIndex = 0; // Loop back to first song
    }

    final nextSong = state.currentQueue[nextIndex];
    playFromQueue(
      song: nextSong,
      queue: state.currentQueue,
      queueType: state.queueType,
      startingIndex: nextIndex,
    );
  }

  void previousSong() {
    if (state.currentSongIndex == null || state.currentQueue.isEmpty) return;

    int prevIndex = state.currentSongIndex! - 1;
    if (prevIndex < 0) {
      prevIndex = state.currentQueue.length - 1; // Loop to last song
    }

    final prevSong = state.currentQueue[prevIndex];
    playFromQueue(
      song: prevSong,
      queue: state.currentQueue,
      queueType: state.queueType,
      startingIndex: prevIndex,
    );
  }

  void seekTo(Duration position) {
    if (state.currentSong == null) return;
    playerService.seek(position);
    state = state.copyWith(currentSongPosition: position);
  }

  void toggleRepeat() {
    state = state.copyWith(isRepeat: !state.isRepeat);
  }

  // ================= FAVOURITES =================
  List<Song> get favouriteSongs => state.allSongs
      .where((song) => state.favouriteMap[song.songID] == true)
      .toList();

  void toggleFavourite(int songID) async {
    final currentStatus = state.favouriteMap[songID] ?? false;
    final newMap = {...state.favouriteMap, songID: !currentStatus};
    state = state.copyWith(favouriteMap: newMap);
    await LocalStorage.setFavouriteMap(newMap);
  }

  Future<void> loadFavourites() async {
    final favMap = LocalStorage.getFavouriteMap();
    state = state.copyWith(favouriteMap: favMap);
  }

  // ================= PLAYLISTS =================
  Future<void> loadPlaylists() async {
    final playlists = LocalStorage.getPlaylists();
    state = state.copyWith(userPlaylists: playlists);
  }

  Future<void> _savePlaylists() async {
    await LocalStorage.savePlaylists(state.userPlaylists);
  }

  void createPlaylist(String name) {
    final newPlaylist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
    );
    state = state.copyWith(
      userPlaylists: [...state.userPlaylists, newPlaylist],
    );
    _savePlaylists();
  }

  void renamePlaylist(String playlistId, String newName) {
    final updated = state.userPlaylists.map((p) {
      if (p.id == playlistId) return p.copyWith(name: newName);
      return p;
    }).toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  void deletePlaylist(String playlistId) {
    final updated = state.userPlaylists
        .where((p) => p.id != playlistId)
        .toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  void addSongToPlaylist(String playlistId, int songId) {
    final updated = state.userPlaylists.map((p) {
      if (p.id == playlistId && !p.songIds.contains(songId)) {
        return p.copyWith(songIds: [...p.songIds, songId]);
      }
      return p;
    }).toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  void removeSongFromPlaylist(String playlistId, int songId) {
    final updated = state.userPlaylists.map((p) {
      if (p.id == playlistId) {
        return p.copyWith(
          songIds: p.songIds.where((id) => id != songId).toList(),
        );
      }
      return p;
    }).toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  List<Song> getSongsInPlaylist(String playlistId) {
    try {
      final playlist = state.userPlaylists.firstWhere(
        (p) => p.id == playlistId,
      );
      return state.allSongs
          .where((song) => playlist.songIds.contains(song.songID))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ================= ALBUMS =================
  List<AlbumModel> albums = [];

  Future<void> fetchAlbums() async {
    final permission = await AudioPermission.request();
    if (!permission) return;

    final loadedAlbums = await audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    albums = loadedAlbums;
  }

  List<Song> getSongsInAlbum(int albumId) {
    return state.allSongs.where((song) => song.albumId == albumId).toList();
  }
}

// ================= QUEUE TYPE ENUM =================
enum QueueType { allSongs, favourites, playlist, album }

// ================= SONGS STATE =================
class SongsState {
  final List<Song> allSongs;
  final List<Song> recentlyPlayedSongs;
  final List<Song> currentQueue;
  final QueueType queueType;

  final bool hasPermission;
  final bool isLoading;
  final Song? currentSong;
  final bool isPlaying;
  final int? currentSongIndex;
  final Duration currentSongPosition;
  final Duration currentSongDuration;
  final Map<int, bool> favouriteMap;
  final bool isRepeat;
  final List<Playlist> userPlaylists;
  final List<Duration> allSongsDuration;
  SongsState({
    required this.allSongs,
    required this.recentlyPlayedSongs,
    required this.currentQueue,
    required this.queueType,
    required this.isLoading,
    required this.hasPermission,
    this.currentSong,
    this.isPlaying = false,
    this.currentSongIndex,
    this.currentSongDuration = Duration.zero,
    this.currentSongPosition = Duration.zero,
    Map<int, bool>? favouriteMap,
    this.isRepeat = false,
    List<Playlist>? userPlaylists,
    required this.allSongsDuration,
  }) : favouriteMap = favouriteMap ?? {},
       userPlaylists = userPlaylists ?? [];

  SongsState copyWith({
    List<Song>? allSongs,
    List<Song>? recentlyPlayedSongs,
    List<Song>? currentQueue,
    QueueType? queueType,
    bool? isLoading,
    bool? hasPermission,
    Song? currentSong,
    bool? isPlaying,
    int? currentSongIndex,
    Duration? currentSongDuration,
    Duration? currentSongPosition,
    Map<int, bool>? favouriteMap,
    bool? isRepeat,
    List<Playlist>? userPlaylists,
    List<Duration>? allSongsDuration,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      recentlyPlayedSongs: recentlyPlayedSongs ?? this.recentlyPlayedSongs,
      currentQueue: currentQueue ?? this.currentQueue,
      queueType: queueType ?? this.queueType,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      currentSongDuration: currentSongDuration ?? this.currentSongDuration,
      currentSongPosition: currentSongPosition ?? this.currentSongPosition,
      favouriteMap: favouriteMap ?? this.favouriteMap,
      isRepeat: isRepeat ?? this.isRepeat,
      userPlaylists: userPlaylists ?? this.userPlaylists,
      allSongsDuration: allSongsDuration ?? this.allSongsDuration,
    );
  }
}
