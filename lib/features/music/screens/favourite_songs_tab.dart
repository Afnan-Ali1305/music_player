import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/features/music/providers/favourites_provider.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';
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
    // Watch only what is needed
    final currentSong = ref.watch(
      songsProvider.select((state) => state.currentSong),
    );

    final currentSongDuration = ref.watch(
      songsProvider.select((state) => state.currentSongDuration),
    );

    // Get favourite songs from favouritesProvider
    final favouriteSongs = ref.read(favouritesProvider.notifier).favouriteSongs;

    if (favouriteSongs.isEmpty) {
      return const Center(
        child: Text("No Favourite Songs", style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: favouriteSongs.length,
      itemBuilder: (context, index) {
        final song = favouriteSongs[index];
        final isCurrent = currentSong?.songID == song.songID;

        return ListTile(
          onTap: () {
            // Play from favourites queue
            ref
                .read(songsProvider.notifier)
                .playFromQueue(
                  song: song,
                  queue:
                      favouriteSongs, // Important: favourites as current queue
                  queueType: QueueType.favourites,
                  startingIndex: index, // Correct starting index
                );
          },
          leading: QueryArtworkWidget(
            id: song.songID,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            artworkBorder: BorderRadius.circular(12),
            artworkHeight: 50,
            artworkWidth: 50,
            keepOldArtwork: true,
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
          title: Text(
            song.songName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.songArtist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isCurrent
              ? const Icon(
                  Icons.equalizer,
                  color: AppColors.darkPrimary,
                  size: 20,
                )
              : Text(
                  formatDuration(currentSongDuration),
                  style: context.textTheme.labelSmall,
                ),
        );
      },
    );
  }
}
