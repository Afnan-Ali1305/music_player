// features/music/widgets/playlist/playlist_song_tile.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/song.dart';

class PlaylistSongTile extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PlaylistSongTile({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.music_note,
        color: isPlaying ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        song.songName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isPlaying ? FontWeight.bold : null,
          color: isPlaying ? Theme.of(context).primaryColor : null,
        ),
      ),
      subtitle: Text(song.songArtist),
      trailing: IconButton(
        icon: const Icon(
          Icons.remove_circle_outline,
          color: Colors.red,
        ),
        onPressed: onRemove,
      ),
      onTap: onTap,
    );
  }
}