// features/music/widgets/playlist/playlist_card.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/.playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final songCount = playlist.songIds.length;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.queue_music, size: 40),
        title: Text(
          playlist.name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text('$songCount songs'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}