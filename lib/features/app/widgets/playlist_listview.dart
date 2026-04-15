// features/music/widgets/playlist/playlist_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/features/app/widgets/create_playlist_dialog.dart';
import 'package:music_player/features/app/widgets/empty_playlist_view.dart';
import 'package:music_player/features/app/widgets/playlist_card.dart';
import 'package:music_player/features/music/providers/playlists_provider.dart';

class PlaylistListView extends ConsumerWidget {
  final Function(String playlistId) onPlaylistTap;

  const PlaylistListView({super.key, required this.onPlaylistTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsState = ref.watch(playlistsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreatePlaylistDialog(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) => const CreatePlaylistDialog(),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: playlistsState.playlists.isEmpty
          ? const EmptyPlaylistsView()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: playlistsState.playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlistsState.playlists[index];
                return PlaylistCard(
                  playlist: playlist,
                  onTap: () => onPlaylistTap(playlist.id),
                );
              },
            ),
    );
  }
}
