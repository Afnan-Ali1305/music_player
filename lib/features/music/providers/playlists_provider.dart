import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/data/local/local_storage_service.dart';
import 'package:music_player/data/models/.playlist.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';

final playlistsProvider = StateNotifierProvider<PlaylistsNotifier, PlaylistsState>((ref) {
  return PlaylistsNotifier(ref);
});

class PlaylistsNotifier extends StateNotifier<PlaylistsState> {
  final Ref ref;

  PlaylistsNotifier(this.ref) : super(PlaylistsState(playlists: [])) {
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    final playlists = LocalStorage.getPlaylists();
    state = state.copyWith(playlists: playlists);
  }

  Future<void> _savePlaylists() async {
    await LocalStorage.savePlaylists(state.playlists);
  }

  void createPlaylist(String name) {
    final newPlaylist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
    );
    state = state.copyWith(playlists: [...state.playlists, newPlaylist]);
    _savePlaylists();
  }

  void renamePlaylist(String playlistId, String newName) {
    final updated = state.playlists.map((p) {
      if (p.id == playlistId) return p.copyWith(name: newName);
      return p;
    }).toList();
    state = state.copyWith(playlists: updated);
    _savePlaylists();
  }

  void deletePlaylist(String playlistId) {
    final updated = state.playlists.where((p) => p.id != playlistId).toList();
    state = state.copyWith(playlists: updated);
    _savePlaylists();
  }

  void addSongToPlaylist(String playlistId, int songId) {
    final updated = state.playlists.map((p) {
      if (p.id == playlistId && !p.songIds.contains(songId)) {
        return p.copyWith(songIds: [...p.songIds, songId]);
      }
      return p;
    }).toList();
    state = state.copyWith(playlists: updated);
    _savePlaylists();
  }

  void removeSongFromPlaylist(String playlistId, int songId) {
    final updated = state.playlists.map((p) {
      if (p.id == playlistId) {
        return p.copyWith(
          songIds: p.songIds.where((id) => id != songId).toList(),
        );
      }
      return p;
    }).toList();
    state = state.copyWith(playlists: updated);
    _savePlaylists();
  }

  List<Song> getSongsInPlaylist(String playlistId) {
    final allSongs = ref.read(songsProvider).allSongs;
    try {
      final playlist = state.playlists.firstWhere((p) => p.id == playlistId);
      return allSongs.where((song) => playlist.songIds.contains(song.songID)).toList();
    } catch (_) {
      return [];
    }
  }
}

class PlaylistsState {
  final List<Playlist> playlists;

  PlaylistsState({required this.playlists});

  PlaylistsState copyWith({List<Playlist>? playlists}) {
    return PlaylistsState(playlists: playlists ?? this.playlists);
  }
}