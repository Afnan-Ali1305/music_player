import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/songs_provider.dart';

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
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.white70),
          ),
          title: Text(songState.allSongs[index].songName),
          subtitle: Text(songState.allSongs[index].songArtist),
          // trailing: IconButton(
          //   icon: const Icon(Icons.more_vert),
          //   onPressed: () {

          //   },
          // ),
          trailing: PopupMenuButton(
            child: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'Play') {
                // _playerService.playSong(songState.allSongs[index].songPath);
                ref.read(songsProvider.notifier).playSong(index);
              } else if (value == 'Pause') {
                ref.read(songsProvider.notifier).pauseSong();
              }
              // ref.read(songsProvider.notifier).songsAction(index, value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Play', child: Text("Play")),
              PopupMenuItem(value: 'Pause', child: Text("Pause")),
            ],
          ),
          // onTap: () {
          //   // TODO: Play song using your audio player provider
          // },
        );
      },
    );
  }
}
