// features/music/widgets/playlist/playlist_songs_list.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/app/widgets/playlist_song_tile.dart';

class PlaylistSongsList extends StatelessWidget {
  final List<Song> songsInPlaylist;
  final String? currentSongId;
  final Function(Song song) onSongTap;
  final Function(String songId) onRemoveSong;

  const PlaylistSongsList({
    super.key,
    required this.songsInPlaylist,
    required this.currentSongId,
    required this.onSongTap,
    required this.onRemoveSong,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: songsInPlaylist.length,
        itemBuilder: (context, index) {
          final song = songsInPlaylist[index];
          final isPlaying = currentSongId == song.songID;

          return PlaylistSongTile(
            song: song,
            isPlaying: isPlaying,
            onTap: () => onSongTap(song),
            onRemove: () => onRemoveSong(song.songID.toString()),
          );
        },
      ),
    );
  }
}