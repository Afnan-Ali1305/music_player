import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/permissions/audio_permission.dart';
import 'package:music_player/services/audio_player_services.dart';
import 'package:on_audio_query/on_audio_query.dart';

final songsProvider = StateNotifierProvider<SongsNotifier, SongsState>((ref) {
  return SongsNotifier();
});

class SongsNotifier extends StateNotifier<SongsState> {
  List<Song> songsList = [];
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
      );

  Future<void> fetchAllSongs() async {
    state = state.copyWith(hasPermission: await AudioPermission.request());

    if (state.hasPermission) {
      final loadedSongs = await audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      songsList = loadedSongs
          .map(
            (s) => Song(
              songID: s.id,
              songArtist: s.artist ?? "Artisit Name",
              songName: s.title,
              songPath: s.uri!,
            ),
          )
          .toList();

      state = state.copyWith(
        isLoading: false,
        recentSongs: songsList.take(2).toList(),
      );
    }

    state = state.copyWith(allSongs: songsList);
  }

  // void songsAction(int index, String value) {
  //   final AudioPlayerService playerService = AudioPlayerService();
  //   if (value == 'Play') {
  //     final song = state.allSongs[index];
  //     playerService.playSong(state.allSongs[index].songPath);

  //     state = state.copyWith(
  //       currentSong: song, // ✅ set current song
  //       isPlaying: true, // ✅ update state
  //       currentSongIndex: index,
  //     );
  //   } else if (value == 'Pause') {
  //     playerService.pause();
  //     state = state.copyWith(isPlaying: false);
  //   }
  // }

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

    final nextSongIndex = state.currentSongIndex! + 1;

    if (nextSongIndex < state.allSongs.length) {
      playSong(nextSongIndex);
    }
  }

  void previousSong() {
    if (state.currentSongIndex == null) return;

    final nextSongIndex = state.currentSongIndex! - 1;

    if (nextSongIndex >= 0) {
      playSong(nextSongIndex);
    }
  }
}

class SongsState {
  List<Song> allSongs;
  List<Song> recentSongs;
  bool hasPermission;
  bool isLoading;

  Song? currentSong; // ✅ NEW
  bool isPlaying; // ✅ NEW
  int? currentSongIndex;

  SongsState({
    required this.allSongs,
    required this.isLoading,
    required this.hasPermission,
    required this.recentSongs,
    this.currentSong,
    this.isPlaying = false,
    this.currentSongIndex,
  });

  SongsState copyWith({
    List<Song>? allSongs,
    bool? isLoading,
    bool? hasPermission,
    List<Song>? recentSongs,
    Song? currentSong,
    bool? isPlaying,
    int? currentSongIndex,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      recentSongs: recentSongs ?? this.recentSongs,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
    );
  }
}
