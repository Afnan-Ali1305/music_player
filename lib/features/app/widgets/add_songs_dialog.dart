// features/music/widgets/playlist/add_songs_dialog.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/.playlist.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/app/widgets/add_songs_search.dart';

class AddSongsDialog extends StatelessWidget {
  final Playlist playlist;
  final List<Song> allSongs;
  final Function(String songId) onAddSong;

  const AddSongsDialog({
    super.key,
    required this.playlist,
    required this.allSongs,
    required this.onAddSong,
  });

  @override
  Widget build(BuildContext context) {
    final songsNotInPlaylist = allSongs
        .where((song) => !playlist.songIds.contains(song.songID))
        .toList();

    return AlertDialog(
      title: const Text('Add Songs'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: AddSongsSearch(
          songs: songsNotInPlaylist,
          onSongTap: (songId) {
            onAddSong(songId);
            Navigator.pop(context);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}