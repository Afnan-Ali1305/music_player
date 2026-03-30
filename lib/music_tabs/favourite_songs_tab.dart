import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/providers/songs_provider.dart';
import 'package:music_player/theme/app_colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteSongsTab extends ConsumerWidget {
  const FavouriteSongsTab({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songState = ref.watch(songsProvider);
    final notifier = ref.watch(songsProvider.notifier);

    final favSongs = notifier.favouriteSongs;

    if (favSongs.isEmpty) {
      return const Center(child: Text("No Favourite Songs"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: favSongs.length,
      itemBuilder: (context, index) {
        final song = favSongs[index];

        final isCurrent = songState.currentSong?.songID == song.songID;

        return ListTile(
          onTap: () {
            // 🔥 IMPORTANT: correct index mapping
            final realIndex = songState.allSongs.indexWhere(
              (s) => s.songID == song.songID,
            );

            if (realIndex != -1) {
              notifier.playSong(realIndex);
            }
          },

          leading: QueryArtworkWidget(
            id: song.songID,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            artworkBorder: BorderRadius.circular(12),
            artworkHeight: 50,
            artworkWidth: 50,
            nullArtworkWidget: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.music_note, color: Colors.white70),
            ),
          ),

          title: Text(song.songName, overflow: TextOverflow.ellipsis),

          subtitle: Text(song.songArtist, overflow: TextOverflow.ellipsis),

          trailing: isCurrent
              ? Icon(Icons.equalizer, color: AppColors.darkPrimary, size: 20)
              : Text(
                  formatDuration(songState.currentSongDuration),
                  style: context.textTheme.labelSmall,
                ),
        );
      },
    );
  }
}
