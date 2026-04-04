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
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/data/local/local_storage_service.dart';
import 'package:music_player/main.dart';
import 'package:music_player/data/models/.playlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/core/utils/audio_permission.dart';
import 'package:music_player/data/services/audio_player_services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

// ================= PROVIDER =================
// Global Riverpod provider that exposes SongsNotifier and SongsState
// to the entire widget tree. Any widget that reads this provider will
// rebuild automatically whenever state changes.
final songsProvider = StateNotifierProvider<SongsNotifier, SongsState>((ref) {
  return SongsNotifier();
});

class SongsNotifier extends StateNotifier<SongsState> {
  // on_audio_query — queries the device's media store for songs and albums
  final OnAudioQuery audioQuery = OnAudioQuery();

  // Our audio handler — the bridge to background playback, notification
  // controls, and lock screen. Accessed via the global instance from main.dart.
  final MyAudioHandler audioHandler = globalAudioHandler as MyAudioHandler;

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

  // ================= INITIALIZATION =================
  Future<void> _init() async {
    // Load persisted data from Hive before anything else so the UI
    // can show favourites and playlists even before songs are fetched
    await loadFavourites();
    await loadPlaylists();

    // Pre-fetch albums
    await fetchAlbums();

    // ---- THE FIX: Register callbacks on the audio handler ----
    // This is the key change that makes notification next/prev buttons work.
    // The handler holds references to these functions and calls them when
    // the system fires skipToNext / skipToPrevious from the notification,
    // lock screen, Bluetooth buttons, or Android Auto.

    // Wire the "next" notification button to our nextSong() logic
    audioHandler.onSkipToNext = () => nextSong();

    // Wire the "previous" notification button to our previousSong() logic
    audioHandler.onSkipToPrevious = () => previousSong();

    // Wire song completion to autoplay or repeat logic.
    // This replaces the old playerStateStream listener that was broken
    // because it only ran when the app was in the foreground.
    audioHandler.onSongComplete = () {
      if (state.isRepeat) {
        // Repeat mode: seek back to start and replay the same song
        if (state.currentSong != null) {
          audioHandler.seek(Duration.zero);
          _playViaHandler(state.currentSong!);
        }
      } else {
        // Autoplay: advance to the next song in the queue
        nextSong();
      }
    };

    // Listen to position stream — updates the seek bar in the UI
    audioHandler.positionStream.listen((position) {
      state = state.copyWith(currentSongPosition: position);
    });

    // Listen to duration stream — updates total song duration once known
    audioHandler.durationStream.listen((duration) {
      state = state.copyWith(currentSongDuration: duration ?? Duration.zero);
    });

    // NOTE: We no longer listen to playerStateStream here for song completion
    // because that is now handled by the onSongComplete callback above which
    // works correctly both in the foreground AND background.
  }

  // ================= FETCH SONGS =================
  // Queries the device's media store for all music files, filters out
  // short clips / WhatsApp audio / recordings, and builds our Song models.
  Future<void> fetchAllSongs() async {
    // Request storage/audio permission before querying
    final permission = await AudioPermission.request();
    if (!permission) {
      state = state.copyWith(hasPermission: false, isLoading: false);
      return;
    }

    // Query all songs sorted by date added (newest first)
    final onlyMusic = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter: keep only actual music files, remove short clips (<3 min),
    // WhatsApp audio, and voice recordings
    final loadedSongs = onlyMusic.where((song) {
      final path = song.data.toLowerCase();
      return song.isMusic == true &&
          (song.duration ?? 0) > 120000 && // longer than 3 minutes
          !path.contains("whatsapp") &&
          !path.contains("record");
    });

    // Map on_audio_query's SongModel to our own Song model
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

    // Restore recently played list from Hive, preserving play order
    final recentIds = LocalStorage.getRecentlyPlayedIds();
    final recentSongs =
        songsList.where((song) => recentIds.contains(song.songID)).toList()
          ..sort(
            (a, b) => recentIds.indexOf(a.songID) - recentIds.indexOf(b.songID),
          );

    // Pre-compute Duration objects for all songs (used in UI to show
    // total duration without repeated millisecond conversions)
    final durationOfSongs = loadedSongs
        .map((song) => Duration(milliseconds: song.duration ?? 0))
        .toList();

    state = state.copyWith(
      allSongs: songsList,
      recentlyPlayedSongs: recentSongs,
      currentQueue: songsList, // Default queue is all songs
      isLoading: false,
      hasPermission: true,
      allSongsDuration: durationOfSongs,
    );
  }

  // ================= RECENTLY PLAYED =================
  // Maintains a "recently played" list capped at 10 songs, newest first.
  // Persisted to Hive so it survives app restarts.
  void _addToRecentlyPlayed(Song song) {
    final currentRecent = List<Song>.from(state.recentlyPlayedSongs);

    // Remove duplicate if the song was already played before
    currentRecent.removeWhere((s) => s.songID == song.songID);

    // Add to the front (most recent = index 0)
    currentRecent.insert(0, song);

    // Cap the list at 10 entries
    if (currentRecent.length > 10) {
      currentRecent.removeLast();
    }

    state = state.copyWith(recentlyPlayedSongs: currentRecent);

    // Persist updated IDs to Hive
    final ids = currentRecent.map((s) => s.songID).toList();
    LocalStorage.saveRecentlyPlayed(ids);
  }

  // ================= INTERNAL PLAY HELPER =================
  // Builds a MediaItem from our Song model and passes it to the handler.
  // MediaItem is what audio_service uses to populate:
  // - Notification title and subtitle
  // - Lock screen "now playing" card
  // - Android Auto / CarPlay / Bluetooth displays
  Future<Uri?> getArtworkUri(Uint8List? artworkBytes, int songId) async {
    if (artworkBytes == null) return null;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/artwork_$songId.jpg');

    await file.writeAsBytes(artworkBytes);
    return file.uri;
  }

  Future<void> _playViaHandler(Song song) async {
    final artworkBytes = await OnAudioQuery().queryArtwork(
      song.songID,
      ArtworkType.AUDIO,
    );

    final artUri = await getArtworkUri(artworkBytes, song.songID);
    final mediaItem = MediaItem(
      // Unique identifier — we use the file path since it is always unique
      id: song.songPath,

      // Primary text shown in the notification (song title)
      title: song.songName,

      // Secondary text shown in the notification (artist name)
      artist: song.songArtist,

      // Album ID stored as string for reference
      album: song.albumId?.toString() ?? '',

      // Duration shown in the notification seek bar.
      // Null is fine here — audio_service will pick it up from the stream.
      duration: state.currentSongDuration != Duration.zero
          ? state.currentSongDuration
          : null,
      artUri: artUri,
      // artUri: Uri.parse('your_artwork_uri_here'),
      // Uncomment and populate artUri to show album art on the notification
      // and lock screen. Use on_audio_query's queryArtwork() to get bytes
      // and save them to a temp file, then pass the file URI here.
    );

    await audioHandler.playSong(song.songPath, mediaItem);
  }

  // ================= QUEUE MANAGEMENT =================
  // Central method for starting playback of any song within any queue.
  // All play actions (all songs, favourites, playlist, album) go through here
  // so the queue context is always set correctly.
  void playFromQueue({
    required Song song,
    required List<Song> queue,
    required QueueType queueType,
    int? startingIndex,
  }) {
    final index =
        startingIndex ?? queue.indexWhere((s) => s.songID == song.songID);

    // Update state immediately so the UI shows the new song before
    // the audio even starts loading (keeps the UI feeling snappy)
    state = state.copyWith(
      currentSong: song,
      currentSongIndex: index,
      currentQueue: queue,
      queueType: queueType,
      isPlaying: true,
    );

    // Tell the handler to play — starts background playback and
    // updates the notification / lock screen with the new song info
    _playViaHandler(song);

    // Record as recently played and persist to Hive
    _addToRecentlyPlayed(song);
  }

  // Convenience method for playing directly from the All Songs list by index.
  // Kept for backward compatibility with existing UI widgets.
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
    audioHandler.pause();
    state = state.copyWith(isPlaying: false);
  }

  void resumeSong() {
    audioHandler.play();
    state = state.copyWith(isPlaying: true);
  }

  // Advance to the next song in the current queue.
  // Called by: in-app next button, notification next button (via callback),
  // autoplay when a song completes (via onSongComplete callback).
  // Wraps around to the first song when the end of the queue is reached.
  void nextSong() {
    if (state.currentSongIndex == null || state.currentQueue.isEmpty) return;

    int nextIndex = state.currentSongIndex! + 1;

    // Wrap around to the beginning of the queue
    if (nextIndex >= state.currentQueue.length) {
      nextIndex = 0;
    }

    final nextSong = state.currentQueue[nextIndex];
    playFromQueue(
      song: nextSong,
      queue: state.currentQueue,
      queueType: state.queueType,
      startingIndex: nextIndex,
    );
  }

  // Go back to the previous song in the current queue.
  // Called by: in-app previous button, notification previous button (via callback).
  // Wraps around to the last song when the beginning of the queue is reached.
  void previousSong() {
    if (state.currentSongIndex == null || state.currentQueue.isEmpty) return;

    int prevIndex = state.currentSongIndex! - 1;

    // Wrap around to the end of the queue
    if (prevIndex < 0) {
      prevIndex = state.currentQueue.length - 1;
    }

    final prevSong = state.currentQueue[prevIndex];
    playFromQueue(
      song: prevSong,
      queue: state.currentQueue,
      queueType: state.queueType,
      startingIndex: prevIndex,
    );
  }

  // Seek to a specific position in the current song.
  // Updates local state immediately so the UI seek bar snaps to the
  // new position without waiting for the next positionStream emission.
  void seekTo(Duration position) {
    if (state.currentSong == null) return;
    audioHandler.seek(position);
    state = state.copyWith(currentSongPosition: position);
  }

  // Toggle repeat mode. When on, the current song replays indefinitely
  // instead of advancing to the next song on completion.
  void toggleRepeat() {
    state = state.copyWith(isRepeat: !state.isRepeat);
  }

  // ================= FAVOURITES =================
  // Returns the subset of allSongs that the user has marked as favourite.
  List<Song> get favouriteSongs => state.allSongs
      .where((song) => state.favouriteMap[song.songID] == true)
      .toList();

  // Toggle the favourite status of a song and persist to Hive.
  void toggleFavourite(int songID) async {
    final currentStatus = state.favouriteMap[songID] ?? false;
    final newMap = {...state.favouriteMap, songID: !currentStatus};
    state = state.copyWith(favouriteMap: newMap);
    await LocalStorage.setFavouriteMap(newMap);
  }

  // Load the persisted favourite map from Hive on startup.
  Future<void> loadFavourites() async {
    final favMap = LocalStorage.getFavouriteMap();
    state = state.copyWith(favouriteMap: favMap);
  }

  // ================= PLAYLISTS =================

  // Load all user-created playlists from Hive on startup.
  Future<void> loadPlaylists() async {
    final playlists = LocalStorage.getPlaylists();
    state = state.copyWith(userPlaylists: playlists);
  }

  // Internal helper — persists current playlist state to Hive after
  // every create / rename / delete / add song / remove song operation.
  Future<void> _savePlaylists() async {
    await LocalStorage.savePlaylists(state.userPlaylists);
  }

  // Create a new empty playlist with a timestamp-based unique ID.
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

  // Rename an existing playlist by its ID.
  void renamePlaylist(String playlistId, String newName) {
    final updated = state.userPlaylists.map((p) {
      if (p.id == playlistId) return p.copyWith(name: newName);
      return p;
    }).toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  // Permanently delete a playlist by its ID.
  void deletePlaylist(String playlistId) {
    final updated = state.userPlaylists
        .where((p) => p.id != playlistId)
        .toList();
    state = state.copyWith(userPlaylists: updated);
    _savePlaylists();
  }

  // Add a song to a playlist. Silently ignores if already present.
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

  // Remove a specific song from a playlist.
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

  // Returns all Song objects in a playlist in the order they were added.
  // Returns an empty list if the playlist ID is not found.
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
  // Cached list of AlbumModel from on_audio_query. Stored as a plain field
  // (not in state) since albums don't change at runtime.
  List<AlbumModel> albums = [];

  // Fetch all albums from the device's media store.
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

  // Returns all songs belonging to a specific album, filtered from
  // the already-loaded allSongs list (no extra device query needed).
  List<Song> getSongsInAlbum(int albumId) {
    return state.allSongs.where((song) => song.albumId == albumId).toList();
  }
}

// ================= QUEUE TYPE ENUM =================
// Tracks which context the current queue came from.
enum QueueType {
  allSongs, // Playing from the main All Songs list
  favourites, // Playing from the Favourites list
  playlist, // Playing from a user-created playlist
  album, // Playing from an album
}

// ================= SONGS STATE =================
// Immutable state object. All changes produce a new instance via copyWith
// so Riverpod can detect changes and rebuild watching widgets.
class SongsState {
  // Complete list of songs found on the device
  final List<Song> allSongs;

  // 10 most recently played songs, newest first
  final List<Song> recentlyPlayedSongs;

  // Active playback queue (all songs / playlist / album / favourites)
  final List<Song> currentQueue;

  // Which context the currentQueue came from
  final QueueType queueType;

  // Whether storage/audio permission has been granted
  final bool hasPermission;

  // Whether the initial song fetch is still in progress
  final bool isLoading;

  // Song currently loaded in the player (null if nothing played yet)
  final Song? currentSong;

  // Whether the player is actively playing (false = paused or stopped)
  final bool isPlaying;

  // Index of currentSong within currentQueue
  final int? currentSongIndex;

  // Current seek position updated ~every 200ms while playing
  final Duration currentSongPosition;

  // Total duration of the current song
  final Duration currentSongDuration;

  // Map of songID → isFavourite for O(1) favourite lookups
  final Map<int, bool> favouriteMap;

  // Whether repeat mode is active
  final bool isRepeat;

  // All user-created playlists
  final List<Playlist> userPlaylists;

  // Pre-computed Duration for every song in allSongs (parallel list)
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

  // Returns a copy of this state with the specified fields replaced.
  // All other fields retain their current values.
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
