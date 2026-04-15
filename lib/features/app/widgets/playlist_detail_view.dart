// features/music/widgets/playlist/playlist_detail_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/features/app/widgets/add_songs_dialog.dart';
import 'package:music_player/features/app/widgets/delete_playlist_dialog.dart';
import 'package:music_player/features/app/widgets/empty_playlist_detail_view.dart';
import 'package:music_player/features/app/widgets/play_all_button.dart';
import 'package:music_player/features/app/widgets/playlist_songs_list.dart';
import 'package:music_player/features/app/widgets/rename_playlist_dialog.dart';
import 'package:music_player/features/music/providers/playlists_provider.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';

class PlaylistDetailView extends ConsumerWidget {
  final String playlistId;
  final VoidCallback onBack;

  const PlaylistDetailView({
    super.key,
    required this.playlistId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsState = ref.watch(playlistsProvider);
    final playlist = playlistsState.playlists.firstWhere(
      (p) => p.id == playlistId,
    );

    final playlistsNotifier = ref.read(playlistsProvider.notifier);
    final songsNotifier = ref.read(songsProvider.notifier);
    final songsInPlaylist = playlistsNotifier.getSongsInPlaylist(playlist.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showRenamePlaylistDialog(context, playlist),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeletePlaylistDialog(context, playlist),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSongsDialog(context, playlist),
        child: const Icon(Icons.add),
      ),
      body: songsInPlaylist.isEmpty
          ? const EmptyPlaylistDetailView()
          : Column(
              children: [
                PlayAllButton(
                  songsInPlaylist: songsInPlaylist,
                  onPlayAll: () {
                    if (songsInPlaylist.isNotEmpty) {
                      songsNotifier.playFromQueue(
                        song: songsInPlaylist.first,
                        queue: songsInPlaylist,
                        queueType: QueueType.playlist,
                      );
                    }
                  },
                ),
                PlaylistSongsList(
                  songsInPlaylist: songsInPlaylist,
                  currentSongId: ref.watch(songsProvider).currentSong!.songID.toString(),
                  onSongTap: (song) {
                    songsNotifier.playFromQueue(
                      song: song,
                      queue: songsInPlaylist,
                      queueType: QueueType.playlist,
                    );
                  },
                  onRemoveSong: (songId) {
                    playlistsNotifier.removeSongFromPlaylist(playlist.id, songId as int);
                  },
                ),
              ],
            ),
    );
  }

  void _showRenamePlaylistDialog(BuildContext context, playlist) {
    final playlistsNotifier = ProviderScope.containerOf(context).read(playlistsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => RenamePlaylistDialog(
        playlist: playlist,
        onRename: (newName) {
          playlistsNotifier.renamePlaylist(playlist.id, newName);
        },
      ),
    );
  }

  void _showDeletePlaylistDialog(BuildContext context, playlist) {
    final playlistsNotifier = ProviderScope.containerOf(context).read(playlistsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => DeletePlaylistDialog(
        playlist: playlist,
        onDelete: () {
          playlistsNotifier.deletePlaylist(playlist.id);
          onBack();
        },
      ),
    );
  }

  void _showAddSongsDialog(BuildContext context, playlist) {
    final playlistsNotifier = ProviderScope.containerOf(context).read(playlistsProvider.notifier);
    final songsState = ProviderScope.containerOf(context).read(songsProvider);
    
    showDialog(
      context: context,
      builder: (ctx) => AddSongsDialog(
        playlist: playlist,
        allSongs: songsState.allSongs,
        onAddSong: (songId) {
          playlistsNotifier.addSongToPlaylist(playlist.id, songId as int);
        },
      ),
    );
  }
}