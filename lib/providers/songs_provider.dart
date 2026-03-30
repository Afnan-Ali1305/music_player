import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/Database/local_storage.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/permissions/audio_permission.dart';
import 'package:music_player/services/audio_player_services.dart';
import 'package:on_audio_query/on_audio_query.dart';

final songsProvider =
    StateNotifierProvider<SongsNotifier, SongsState>((ref) {
  return SongsNotifier();
});

class SongsNotifier extends StateNotifier<SongsState> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayerService playerService = AudioPlayerService();

  SongsNotifier()
      : super(
          SongsState(
            allSongs: [],
            recentSongs: [],
            isLoading: true,
            hasPermission: false,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    await loadFavourites();

    playerService.positionStream.listen((position) {
      state = state.copyWith(currentSongPosition: position);
    });

    playerService.durationStream.listen((duration) {
      state = state.copyWith(
        currentSongDuration: duration ?? Duration.zero,
      );
    });
  }

  // ================= FETCH SONGS =================

  Future<void> fetchAllSongs() async {
    final permission = await AudioPermission.request();

    if (!permission) {
      state = state.copyWith(hasPermission: false, isLoading: false);
      return;
    }

    final loadedSongs = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    final songsList = loadedSongs
        .map(
          (s) => Song(
            songID: s.id,
            songArtist: s.artist ?? "Artist Name",
            songName: s.title,
            songPath: s.uri!,
          ),
        )
        .toList();

    state = state.copyWith(
      allSongs: songsList,
      recentSongs: songsList.take(2).toList(),
      isLoading: false,
      hasPermission: true,
    );
  }

  // ================= PLAYER =================

  void playSong(int index) {
    final song = state.allSongs[index];

    playerService.playSong(song.songPath);

    state = state.copyWith(
      currentSong: song,
      currentSongIndex: index,
      isPlaying: true,
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
    if (state.currentSongIndex == null) return;

    final nextIndex = state.currentSongIndex! + 1;

    if (nextIndex < state.allSongs.length) {
      playSong(nextIndex);
    }
  }

  void previousSong() {
    if (state.currentSongIndex == null) return;

    final prevIndex = state.currentSongIndex! - 1;

    if (prevIndex >= 0) {
      playSong(prevIndex);
    }
  }

  void seekTo(Duration position) {
    if (state.currentSong == null) return;

    playerService.seek(position);
    state = state.copyWith(currentSongPosition: position);
  }

  // ================= FAVOURITES =================

  List<Song> get favouriteSongs {
    return state.allSongs
        .where((song) => state.favouriteMap[song.songID] == true)
        .toList();
  }

  void toggleFavourite(int songID) async {
    final currentStatus = state.favouriteMap[songID] ?? false;

    final newMap = {
      ...state.favouriteMap,
      songID: !currentStatus,
    };

    state = state.copyWith(favouriteMap: newMap);

    await LocalStorage.setFavouriteMap(newMap);
  }

  Future<void> loadFavourites() async {
    final favMap = await LocalStorage.getFavouriteMap();
    state = state.copyWith(favouriteMap: favMap);
  }
}

// ================= STATE =================

class SongsState {
  final List<Song> allSongs;
  final List<Song> recentSongs;

  final bool hasPermission;
  final bool isLoading;

  final Song? currentSong;
  final bool isPlaying;
  final int? currentSongIndex;

  final Duration currentSongPosition;
  final Duration currentSongDuration;

  final Map<int, bool> favouriteMap;
  

  SongsState({
    required this.allSongs,
    required this.recentSongs,
    required this.isLoading,
    required this.hasPermission,
    this.currentSong,
    this.isPlaying = false,
    this.currentSongIndex,
    this.currentSongDuration = Duration.zero,
    this.currentSongPosition = Duration.zero,
    Map<int, bool>? favouriteMap,
  }) : favouriteMap = favouriteMap ?? {};

  SongsState copyWith({
    List<Song>? allSongs,
    List<Song>? recentSongs,
    bool? isLoading,
    bool? hasPermission,
    Song? currentSong,
    bool? isPlaying,
    int? currentSongIndex,
    Duration? currentSongDuration,
    Duration? currentSongPosition,
    Map<int, bool>? favouriteMap,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      recentSongs: recentSongs ?? this.recentSongs,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      currentSongDuration: currentSongDuration ?? this.currentSongDuration,
      currentSongPosition: currentSongPosition ?? this.currentSongPosition,
      favouriteMap: favouriteMap ?? this.favouriteMap,
    );
  }
}