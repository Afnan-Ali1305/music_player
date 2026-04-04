import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsTab extends ConsumerStatefulWidget {
  // final List<Song> allSongs;
  const SongsTab({
    super.key,

    // required this.allSongs
  });

  @override
  ConsumerState<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends ConsumerState<SongsTab> {
  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(songsProvider);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount:
          songState.allSongs.length, // Replace with your songs provider length
      itemBuilder: (context, index) {
        return ListTile(
          // onTap: () async {
          //   // Pass the URI from your LocalSong model to the service
          //   await _playerService.playSong(widget.allSongs[index].songPath);

          //   // Optional: Show a "Now Playing" snackbar or update UI state
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text("Playing: ${widget.allSongs[index].songName}"),
          //     ),
          //   );
          // },
          // onTap: () {
          //   context.router.push(const PlayerRoute());
          // },
          leading: QueryArtworkWidget(
            id: songState.allSongs[index].songID,
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
            songState.allSongs[index].songName,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            songState.allSongs[index].songArtist,
            overflow: TextOverflow.ellipsis,
          ),
          // trailing: IconButton(
          //   icon: const Icon(Icons.more_vert),
          //   onPressed: () {

          //   },
          // ),
          // trailing: PopupMenuButton(
          //   child: Icon(Icons.more_vert),
          //   onSelected: (value) {
          //     if (value == 'Play') {
          //       // _playerService.playSong(songState.allSongs[index].songPath);
          //       ref.read(songsProvider.notifier).playSong(index);
          //     } else if (value == 'Pause') {
          //       ref.read(songsProvider.notifier).pauseSong();
          //     } else if (value == 'fave') {
          //       ref
          //           .read(songsProvider.notifier)
          //           .toggleFavourite(songState.allSongs[index].songID);
          //     }
          //     // ref.read(songsProvider.notifier).songsAction(index, value);
          //   },
          //   itemBuilder: (context) => [
          //     PopupMenuItem(value: 'Play', child: Text("Play")),
          //     PopupMenuItem(value: 'Pause', child: Text("Pause")),
          //     PopupMenuItem(value: 'fav', child: Text("fav")),
          //   ],
          // ),
          trailing: ref.watch(songsProvider).currentSongIndex == index
              ? Icon(Icons.equalizer, color: AppColors.darkPrimary, size: 20)
              : Text(
                  // formatDuration(songState.currentSongDuration),
                  formatDuration(songState.allSongsDuration[index]),
                  style: context.textTheme.labelSmall,
                ),
          onTap: () {
            // TODO: Play song using your audio player provider
            ref
                .read(songsProvider.notifier)
                .playFromQueue(
                  song: songState.allSongs[index],
                  queue: songState.allSongs, // Pass full list as queue
                  queueType: QueueType.allSongs,
                  startingIndex: index,
                );
          },
        );
      },
    );
  }
}
