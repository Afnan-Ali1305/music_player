// features/music/widgets/playlist/play_all_button.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/song.dart';

class PlayAllButton extends StatelessWidget {
  final List<Song> songsInPlaylist;
  final VoidCallback onPlayAll;

  const PlayAllButton({
    super.key,
    required this.songsInPlaylist,
    required this.onPlayAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: songsInPlaylist.isNotEmpty ? onPlayAll : null,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play All'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}